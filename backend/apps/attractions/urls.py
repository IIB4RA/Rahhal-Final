from django.urls import include, path
from rest_framework.routers import DefaultRouter

from .views import HotelView, AttractionView, EventView, TourView

router = DefaultRouter()
router.register("hotel", HotelView, basename="hotel")
router.register("attraction", AttractionView, basename="attraction")
router.register("event", EventView, basename="event")
router.register("tour", TourView, basename="tour")
router.register("attrcation-content", TourView, basename="attrcation-content")

urlpatterns = [path("", include(router.urls))]
