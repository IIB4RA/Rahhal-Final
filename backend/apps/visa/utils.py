import jwt
from django.utils import timezone
from datetime import timedelta
from django.conf import settings


def generate_pass_jwt(user_id, pass_code, nationality):

    payload = {
        "u_id": str(user_id),
        "nat": nationality,
        "p_c": pass_code,
        "iat": timezone.now().timestamp(),
        "exp": (timezone.now() + timedelta(days=90)).timestamp()
    }

    token = jwt.encode(payload, settings.SECRET_KEY, algorithm="HS256")
    return token