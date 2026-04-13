from rest_framework import serializers
from .models import Hotel, Attraction, Tour, Event, Attraction_Content

class HotelSerializer(serializers.ModelSerializer):
    region_name_en = serializers.CharField(source="region_id.name_en", read_only=True)
    region_name_ar = serializers.CharField(source="region_id.name_ar", read_only=True)

    class Meta:
        model = Hotel
        fields = (
            "id",
            "region_id",
            "region_name_en",
            "region_name_ar",
            "name_en",
            "name_ar",
            "stars",
            "total_rooms",
            "price_per_night",
            "latitude",
            "longitude",
            "image_url",
        )



class AttractionSerializer(serializers.ModelSerializer):
    region_name_en = serializers.CharField(source="region_id.name_en", read_only=True)
    region_name_ar = serializers.CharField(source="region_id.name_ar", read_only=True)

    class Meta:
        model = Attraction
        fields = (
            "id",
            'region_id',
            "region_name_en",
            "region_name_ar",
            'name_en',
            'name_ar',
            'category',
            'latitude',
            'longitude',
            'entry_fee',
            'description_en',
            'description_ar',
            'image_url',
            'avg_rating',
            'total_reviews',
        )




class TourSerializer(serializers.ModelSerializer):
    region_name_en = serializers.CharField(source="region_id.name_en", read_only=True)
    region_name_ar = serializers.CharField(source="region_id.name_ar", read_only=True)

    operator_name = serializers.CharField(source="operator_id.name", read_only=True)

    class Meta:
        model = Tour
        fields = (
            'id',
            'region_id',
            'operator_id'
            "region_name_en",
            "region_name_ar",
            'operator_name'
            'name_en',
            'name_ar',
            'description_en',
            'description_ar',
            'price',
            'max_guests',
            'duration_hours',
            'image_url',
        )




class EventSerializer(serializers.ModelSerializer):
    region_name_en = serializers.CharField(source="region_id.name_en", read_only=True)
    region_name_ar = serializers.CharField(source="region_id.name_ar", read_only=True)

    class Meta:
        model = Event
        fields = (
            'id',
            'region_id',
            "region_name_en",
            "region_name_ar",
            'name_en',
            'name_ar',
            'description_en',
            'description_an',
            'location',
            'latitude',
            'longitude',
            "event_date",
            'price',
            'image_url',
        )




class AttractionContentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Attraction_Content
        fields = (
            'id',
            'attraction_id',
            'type',
            'language',
            'content_url',
        )