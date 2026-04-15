from django.urls import path
from .views import AITripPlannerView

urlpatterns = [
    path('generate/', AITripPlannerView.as_view(), name='ai_trip_planner'),
]