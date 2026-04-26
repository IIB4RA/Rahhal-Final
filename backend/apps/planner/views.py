import json
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from openai import OpenAI
from decouple import config

_openai_key = config('OPENAI_API_KEY', default='')
client = OpenAI(api_key=_openai_key) if _openai_key else None

@method_decorator(csrf_exempt, name='dispatch')
class AITripPlannerView(APIView):
    permission_classes = [AllowAny]
    
    def post(self, request):
        user_input = request.data.get('prompt', '').strip()
        chat_history = request.data.get('history', []) 
        
        if not user_input:
            return Response({"success": False, "error": "Input is empty"}, status=400)

        try:
            
            context = "Previous Conversation History:\n"
            for msg in chat_history[-6:]: 
                role = "User" if msg['role'] == "user" else "Assistant"
                context += f"{role}: {msg['content']}\n"
            
            full_prompt = f"{context}\nCurrent User Input: {user_input}"

            
            response = client.responses.create(
                model="gpt-4o",
                instructions="""You are Rahhal, an elite universal agent with a perfect memory of the conversation above.
                1. CONTEXT: Use the 'Previous Conversation History' to understand what the user is referring to.
                2. SEARCH: Use the web_search tool for real-time data or to clarify locations.
                3. STYLE: Markdown formatted, witty, and helpful.""",
                input=full_prompt,
                tools=[{"type": "web_search"}], 
                store=True, 
            )

            output_text = ""
            citations = []
            
            for item in response.output:
                if item.type == "message":
                    output_text = item.content[0].text
                    if hasattr(item.content[0], 'annotations'):
                        citations = [
                            {"url": a.url, "title": a.title} 
                            for a in item.content[0].annotations if a.type == "url_citation"
                        ]

            return Response({
                "success": True, 
                "plan": {
                    "chat_reply": output_text,
                    "citations": citations,
                }
            })

        except Exception as e:
            print(f"Error: {str(e)}")
            return Response({"success": False, "error": str(e)}, status=500)