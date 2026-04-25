class AnalyticsMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
      
        if response.status_code == 200 and not request.path.startswith('/admin'):
            try:
       
                from .models import VisitorLog 
                
                VisitorLog.objects.create(
                    user=request.user if request.user.is_authenticated else None,
                    device_type=request.META.get('HTTP_USER_AGENT', 'Unknown')[:50],
                    ip_address=request.META.get('REMOTE_ADDR')
                )
            except Exception as e:
         
                print(f"Analytics Error: {e}") 
                pass
                
        return response