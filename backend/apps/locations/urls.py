from django.urls import path
from .views import locations

urlpatterns = [
    path('', locations, name='locations'),
]
