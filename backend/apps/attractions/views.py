from rest_framework import permissions, viewsets
from .models import Hotel, Attraction, Tour, Event, Attraction_Content
from .serializers import HotelSerializer, AttractionSerializer, TourSerializer, EventSerializer, AttractionContentSerializer

class HotelView(viewsets.ReadOnlyModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = HotelSerializer

    def get_queryset(self):
        queryset = Hotel.objects.all()
        region = self.request.query_params.get('region') 

        if region:
            queryset = queryset.filter(region_id=region)

        return queryset


class AttractionView(viewsets.ReadOnlyModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = AttractionSerializer

    def get_queryset(self):
        queryset = Attraction.objects.all()
        region = self.request.query_params.get('region') 

        if region:
            queryset = queryset.filter(region_id=region)

        return queryset



class TourView(viewsets.ReadOnlyModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = TourSerializer

    def get_queryset(self):
        queryset = Tour.objects.all()
        region = self.request.query_params.get('region') 
        operator = self.request.query_params.get('operator')

        if region:
            queryset = queryset.filter(region_id=region)
        if operator:
            queryset = queryset.filter(operator_id=operator)

        return queryset




class EventView(viewsets.ReadOnlyModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = EventSerializer

    def get_queryset(self):
        queryset = Event.objects.all()
        region = self.request.query_params.get('region') 

        if region:
            queryset = queryset.filter(region_id=region)

        return queryset
    


class AttractionContentView(viewsets.ReadOnlyModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = AttractionContentSerializer

    def get_queryset(self):
        attraction_id = self.request.query_params.get('attraction_id')
        queryset = Attraction_Content.objects.all()
        
        if attraction_id is not None:
            queryset = queryset.filter(attraction_id=attraction_id)

        return queryset

