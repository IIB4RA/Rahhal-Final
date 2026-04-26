from django.contrib import admin
from django.urls import path, include
from django.http import JsonResponse
from apps.accounts.views import PassportScannerView

def health_check(request):
    return JsonResponse({"status": "ok"})

urlpatterns = [
    path('', health_check),
    path('admin/', admin.site.urls),
    path('api/', include("apps.accounts.urls")),
    path('api/visa/', include("apps.visa.urls")),
    path('api/tourism/', include("apps.attractions.urls")),
    path('api/booking/', include("apps.booking.urls")),
    path('api/passport/scan/', PassportScannerView.as_view(), name='passport_scan'),
    path('api/planner/', include("apps.planner.urls")),
    path('api/locations/', include("apps.locations.urls")),
    path('api/admin/', include('apps.admin.urls')),
]
