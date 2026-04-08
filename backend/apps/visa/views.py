from rest_framework import permissions, status, viewsets
from rest_framework.response import Response
from rest_framework import APIView
from rest_framework.decorators import action
from django.utils import timezone
from datetime import timedelta
from .permissions import IsInternationalTourist

from .models import applications, passports, tourist_pass, pass_usage
from .serializers import AdminApplicationListSerializer, PassportSerializer, VisaApplicationSerializer, CreateVisaSerializer, OCRSerializer, DigitalPassSerializer


class VisaApplicationView(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated, IsInternationalTourist]

    def get_queryset(self):
        return applications.objects.filter(user=self.request.user)
    
    def get_serializer_class(self):
        if self.action == "create":
            return CreateVisaSerializer
        return VisaApplicationSerializer
    
    def perform_create(self, serializer):
        passport_info = serializer.validated_data.pop("passport_data")

        new_passport = passports.objects.create(user=self.request.user,**passport_info)

        serializer.save(user=self.request.user, passport_id=new_passport, status="SUBMITTED")



class OCRView(APIView):
    permission_classes = [permissions.IsAuthenticated, IsInternationalTourist]

    def post(self, request):
        serializer = OCRSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        #OCR

        extracted_data = {
            'full_name':'test name',
            'passport_number':'test_number',
            'nationality':'test_nationality',
            'birth_date':'test_date',
            'gender':'test_gender',
            'date_of_expiry':'test_date',
            'issuing_country':'test_country'
        }

        return Response({"extracted":extracted_data}, status=status.HTTP_200_OK)



class DigitalPassView(viewsets.ReadOnlyModelViewSet):
    permission_classes = [permissions.IsAuthenticated, IsInternationalTourist]
    serializer_class = DigitalPassSerializer

    def get_queryset(self):
        return tourist_pass.objects.filter(user=self.request.user)
    

class AdminVisaManagementView(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated, permissions.IsAdmin]
    serializer_class = VisaApplicationSerializer
    queryset = applications.objects.all()

    def get_serializer_class(self):
        if self.action == 'list':
            return AdminApplicationListSerializer 
        return VisaApplicationSerializer 

    @action(detail=True, methods=['post'])
    def approve_visa(self, request, pk=None):
        application = self.get_object()

        application.status = "APPROVED"
        application.processed_date = timezone.now()
        application.save()

        expiry = timezone.now() + timedelta(days=90)

        #QR code/digital pass

        new_pass = tourist_pass.objects.create(
            user_id=application.user_id,
            visa_id=application,           
            pass_code="test",  
            qr_data="test",       
            status="ACTIVE",
            issued_date=timezone.now(),
            expiry_date=expiry
            )

        return Response({"message": "Visa approved and Digital Pass generated!","pass_id": new_pass.id}, status=status.HTTP_200_OK)

    @action(detail=True, methods=['post'])
    def reject_visa(self, request, pk=None):
        application = self.get_object()
        reason = request.data.get("rejection_reason")

        if not reason:
            return Response({"error": "Provide a specific reason for rejection."}, status=status.HTTP_400_BAD_REQUEST)
        
        application.status = "REJECTED"
        application.rejection_reason = reason
        application.processed_date = timezone.now()
        application.save()
        
        return Response({"message": f"Visa rejected. Reason: {reason}"}, status=status.HTTP_200_OK)
