import csv
from django.http import HttpResponse
from django.db.models import Count, Sum, Avg, Q
from django.db.models.functions import ExtractMonth
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from datetime import datetime, timedelta

# App Imports
from apps.analytics.models import VisitorLog
from apps.accounts.models import User
from apps.attractions.models import Attraction
from apps.locations.models import Region
from apps.payment.models import Transaction
from rest_framework.permissions import AllowAny

class MinistryAnalyticsView(APIView):

    authentication_classes = [] 
    permission_classes = [AllowAny] 
    def get(self, request):
        try:
            total_tourists = User.objects.filter(role='tourist').count()
            
            revenue = Transaction.objects.filter(status='paid').aggregate(Sum('amount'))['amount__sum'] or 0
            
            avg_stay_mins = VisitorLog.objects.aggregate(Avg('duration_mins'))['duration_mins__avg'] or 0
            avg_stay_days = round(avg_stay_mins / 1440, 1) if avg_stay_mins > 0 else 0

            top_attractions = Attraction.objects.order_by('-avg_rating')[:3].values('name_en', 'avg_rating')

            segmentation = User.objects.values('nationality').annotate(
                count=Count('id')
            ).order_by('-count')[:4]

           
            # monthly_trend = VisitorLog.objects.annotate(
            #     month=ExtractMonth('created_at')
            # ).values('month').annotate(count=Count('id')).order_by('month')
            monthly_trend = None

            map_data = Region.objects.annotate(
                visitors_count=Count('visitorlog')
            ).values('name_en', 'latitude', 'longitude', 'visitors_count')

            return Response({
                "success": True,
                "data": {
                    "stats": {
                        "tourists": f"{total_tourists/1000:.1f}k" if total_tourists > 1000 else str(total_tourists),
                        "revenue": f"JD {revenue/1000:.1f}k",
                        "bookings": "85.4K", 
                        "avg_stay": f"{avg_stay_days} Days"
                    },
                    "attractions": list(top_attractions),
                    "segmentation": list(segmentation),
                    "trends": [item['count'] for item in monthly_trend] if monthly_trend else [15, 20, 18, 25, 22, 30],
                    "map_pins": list(map_data)
                }
            })

        except Exception as e:
            return Response({
                "success": False, 
                "error": str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class ExportAnalyticsCSV(APIView):

    authentication_classes = [] 
    permission_classes = [AllowAny]

    def get(self, request):
        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = f'attachment; filename="ZAD_Executive_Report_{datetime.now().date()}.csv"'
        
        writer = csv.writer(response)
        writer.writerow(['Metric', 'Value', 'Timestamp'])
        
        writer.writerow(['Total Tourists', User.objects.count(), datetime.now()])
        writer.writerow(['Total Revenue (JD)', Transaction.objects.aggregate(Sum('amount'))['amount__sum'] or 0, datetime.now()])
        
        writer.writerow([])
        writer.writerow(['Top Attractions', 'Rating'])
        for att in Attraction.objects.all()[:10]:
            writer.writerow([att.name_en, att.avg_rating])

        return response