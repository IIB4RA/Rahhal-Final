import json
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny  # 1. أضفنا هذا السطر
from openai import OpenAI
from decouple import config

client = OpenAI(api_key=config('OPENAI_API_KEY'))


TRIP_PLANNER_PROMPT = """
You are an elite, highly professional AI Assistant for Jordan tourism.
You must analyze the user's prompt and decide how to respond.

RULES:
1. If the user asks a general question (e.g., greetings, weather, history, tips), set "is_itinerary" to false and write a helpful, conversational answer in "chat_reply".
2. If the user explicitly asks for a travel plan, schedule, or itinerary, set "is_itinerary" to true and fill out the detailed itinerary fields.
3. LANGUAGE RULE: You MUST respond in the exact same language the user uses. If the user writes in Arabic, your ENTIRE JSON response (chat_reply, destination, themes, descriptions, ai_advice) MUST be fully translated into Arabic.
You MUST return a valid JSON object with the exact following structure:
{
  "is_itinerary": boolean,
  "chat_reply": "Your conversational answer here (leave empty if providing an itinerary)",
  "destination": "Name of the main region/city (if itinerary)",
  "total_days": int (if itinerary),
  "estimated_budget_usd": int (if itinerary),
  "itinerary": [
    {
      "day": int,
      "theme": "Brief title",
      "activities": [
        {
          "time": "Morning/Afternoon/Evening",
          "place": "Name of place",
          "description": "1 short sentence",
          "cost_estimate_usd": int
        }
      ]
    }
  ],
  "ai_advice": "One strict travel tip."
}
"""
class AITripPlannerView(APIView):
    permission_classes = [AllowAny]  # 2. أضفنا هذا السطر لفتح الصلاحية بدون تسجيل دخول

    def post(self, request):
        user_prompt = request.data.get('prompt', '')

    def post(self, request):
        user_prompt = request.data.get('prompt', '')
        days = request.data.get('days', 3)
        budget = request.data.get('budget', 'Medium')
        
        if not user_prompt:
            return Response({"error": "Please tell me what kind of trip you want."}, status=status.HTTP_400_BAD_REQUEST)


        context_message = f"""
        User Context:
        - Budget: {budget}
        - Requested Days: {days}
        - User Request: {user_prompt}
        
        Generate the JSON itinerary strictly matching the requested days and budget in Jordan.
        """

        try:

            api_response = client.chat.completions.create(
                model="gpt-4o-mini", 
                response_format={ "type": "json_object" },
                temperature=0.7, 
                messages=[
                    {"role": "system", "content": TRIP_PLANNER_PROMPT},
                    {"role": "user", "content": context_message}
                ]
            )

            plan_data = json.loads(api_response.choices[0].message.content)

            return Response({"success": True, "plan": plan_data}, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({"success": False, "error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)