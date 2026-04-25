from django.contrib import admin
from django.urls import path, include
from apps.accounts.views import PassportScannerView
urlpatterns = [
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
