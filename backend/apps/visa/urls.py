from django.urls import include, path
from rest_framework.routers import DefaultRouter
from .views import VisaApplicationView, DigitalPassView, OCRView, AdminVisaManagementView  

router = DefaultRouter()
router.register("applications", VisaApplicationView, basename="visa-application")
router.register("pass", DigitalPassView, basename="tourist-pass")
router.register("admin-visa", AdminVisaManagementView, basename="admin-visa-management")

urlpatterns = [
    path("", include(router.urls)),
    path("ocr/", OCRView.as_view(), name="visa-ocr")
]