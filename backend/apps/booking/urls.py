from django.urls import include, path
from rest_framework.routers import DefaultRouter

from .views import HotelBookingView, TransportBookingView, TourBookingView

router = DefaultRouter()
router.register("book-hotel", HotelBookingView, basename="book-hotel")
router.register("book-tour", TourBookingView, basename="book-tour")
router.register("book-transport", TransportBookingView, basename="book-transport")

urlpatterns = [path("", include(router.urls))]
