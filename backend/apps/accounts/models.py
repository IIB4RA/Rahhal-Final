import uuid
from django.db import models
from django.utils import timezone
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager

class CustomUserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password) 
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('role', 'admin')
        return self.create_user(email, password, **extra_fields)

class User(AbstractBaseUser):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    email = models.EmailField(unique=True)
    password = models.TextField(db_column='password_hash')
    
    full_name = models.CharField(max_length=255, null=True, blank=True)
    passport_number = models.CharField(max_length=50, null=True, blank=True)
    nationality = models.CharField(max_length=100, null=True, blank=True)
    arrival_date = models.CharField(max_length=50, null=True, blank=True) 
    departure_date = models.CharField(max_length=50, null=True, blank=True)
    
    language = models.CharField(max_length=10, default='en')
    phone = models.TextField(unique=True, null=True, blank=True)
    avatar_url = models.TextField(null=True, blank=True)

    role = models.CharField(max_length=21, default='tourist')
    status = models.CharField(max_length=9, default='active')

    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(default=timezone.now)

    objects = CustomUserManager()

    @property
    def is_staff(self):
        return self.role == 'admin'

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    

    class Meta:
        db_table = 'accounts"."users'
        managed = False 