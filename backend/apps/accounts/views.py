import base64
import json
from django.contrib.auth import get_user_model
from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.parsers import MultiPartParser
from rest_framework_simplejwt.tokens import RefreshToken
from openai import OpenAI
from decouple import config
from .serializers import LoginSerializer, MeSerializer, RegisterSerializer, RoleSerializer, UpdateProfileSerializer

User = get_user_model()

# FIX: Passed the key directly as a string instead of using config()
OPENAI_API_KEY = config('OPENAI_API_KEY', default='')
client = OpenAI(api_key=OPENAI_API_KEY) if OPENAI_API_KEY else None

SYSTEM_PROMPT = """
You are a highly accurate Passport OCR data extractor. 
Analyze the provided passport image and extract the information.
The output MUST be a valid JSON object with these exact keys:
{
  "surname": "Last name here",
  "given_names": "First and middle names here",
  "document_number": "Passport number here",
  "nationality": "Country code (e.g., CAN, USA)",
  "date_of_birth": "DD MMM YYYY",
  "sex": "Male or Female",
  "expiry_date": "DD MMM YYYY",
  "raw_mrz": "The 2 lines of text at the bottom. Use \\n to separate the lines.",
  "checksum_valid": true
}
"""


def generate_user_tokens(user):
    token = RefreshToken.for_user(user)
    return {
        "refresh_token": str(token),
        "access_token": str(token.access_token),
        "user": MeSerializer(user).data
    }


class RegisterView(generics.CreateAPIView):
    serializer_class = RegisterSerializer
    permission_classes = [permissions.AllowAny]

    def create(self, request):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        return Response(generate_user_tokens(user), status=status.HTTP_201_CREATED)


class LoginView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data["user"]
        return Response(generate_user_tokens(user), status=status.HTTP_200_OK)


class MeView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        serializer = MeSerializer(request.user)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def patch(self, request):
        serializer = UpdateProfileSerializer(
            instance=request.user,
            data=request.data,
            context={"request": request},
            partial=True,
        )
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(MeSerializer(request.user).data, status=status.HTTP_200_OK)


class RoleView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        serializer = RoleSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save(user=request.user)
        return Response({"user": MeSerializer(user).data}, status=status.HTTP_200_OK)


class PassportScannerView(APIView):
    permission_classes = [permissions.AllowAny]
    parser_classes = [MultiPartParser]

    def post(self, request, *args, **kwargs):
        if not client:
            return Response({"success": False, "error": "OpenAI API key not configured"}, status=status.HTTP_503_SERVICE_UNAVAILABLE)

        image_file = request.FILES.get('image')
        if not image_file:
            return Response({"success": False, "error": "No image provided"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            img_content = image_file.read()
            base64_image = base64.b64encode(img_content).decode('utf-8')

            api_response = client.chat.completions.create(
                model="gpt-4o",
                response_format={"type": "json_object"},
                temperature=0.0,
                messages=[
                    {
                        "role": "system",
                        "content": SYSTEM_PROMPT
                    },
                    {
                        "role": "user",
                        "content": [
                            {"type": "text", "text": "Extract passport details."},
                            {
                                "type": "image_url",
                                "image_url": {
                                    "url": f"data:image/jpeg;base64,{base64_image}"
                                }
                            }
                        ]
                    }
                ]
            )

            extracted_data = json.loads(api_response.choices[0].message.content)

            return Response({
                "success": True,
                "data": extracted_data
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({
                "success": False,
                "error": str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)