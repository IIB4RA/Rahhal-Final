from rest_framework import serializers
from .models import applications, passports, tourist_pass, pass_usage


class PassportSerializer(serializers.ModelSerializer):
    class Meta:
        model = passports
        fields = (
            'user_id',
            'passport_number',
            'full_name',
            'nationality',
            'birth_date',
            'expiry_date',
            'scan_url',
            'created_at'
        )
        read_only_fields = ('user_id', 'created_at')



class VisaApplicationSerializer(serializers.ModelSerializer):
    passport_details = PassportSerializer()

    class Meta:
        model = applications
        fields = (
            "user_id",
            "passport_id",
            "passport_details",
            "visa_type",
            "status",
            "applied_date",
            "processed_date",
            "processing_days",
            "rejection_reason",
            "payment_id",
            "created_at",
            "updated_at",
        )
        read_only_fields = (
            "user_id",
            "passport_id",
            "status", 
            "applied_date", 
            "processed_date", 
            "processing_days", 
            "rejection_reason", 
            "payment_id", 
            "created_at", 
            "updated_at")



class CreateVisaSerializer(serializers.ModelSerializer):
    class Meta:
        model = applications
        fields = ("visa_type", "passport_data")



class OCRSerializer(serializers.Serializer):
    image_base = serializers.CharField(required=False, allow_blank=True)
    image_url = serializers.URLField(required=False)



class DigitalPassSerializer(serializers.ModelSerializer):
    class Meta:
        model = tourist_pass
        fields = (
            "user_id",
            "visa_id",
            "pass_code",
            "qr_data",
            "status",
            "issued_date",
            "expiry_date",
            "created_at",
        )
        read_only_fields = fields



class AdminApplicationListSerializer(serializers.ModelSerializer):
    tourist_name = serializers.CharField(source='user_id.username', read_only=True)

    class Meta:
        model = applications
        fields = (
            "user_id", 
            "visa_type", 
            "status", 
            "applied_date"
        )