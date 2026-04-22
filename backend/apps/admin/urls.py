from django.urls import path
from .views import MinistryAnalyticsView, ExportAnalyticsCSV

urlpatterns = [
    # Match: /api/admin/analytics/
    path('analytics/', MinistryAnalyticsView.as_view(), name='ministry-analytics'),
    
    # Match: /api/admin/export/
    path('export/', ExportAnalyticsCSV.as_view(), name='export-analytics-csv'),
]