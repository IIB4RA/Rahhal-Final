import uuid
from .models import Transaction

def process_mock_payment(amount, currency="JOD"):
    """
    Simulates a bank response. In reality, this would 
    call a library like Stripe or a local bank API.
    """
    
    bank_ref = f"BANK-{uuid.uuid4().hex[:8].upper()}"
    
    return {
        "success": True,
        "reference": bank_ref,
        "provider": "Visa/Mock"
    }