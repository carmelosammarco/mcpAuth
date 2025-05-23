"""
Mock User Database with API Keys

This module provides a simple in-memory user database with API keys for authentication.
"""

from typing import Dict, Optional

# Simple user database with API keys
users = {
    "user": {
        "api_key": "123456789",
        "full_name": "User Test",
        "role": "admin"
    }
}

# Lookup table to quickly find user by API key
api_key_to_user: Dict[str, str] = {
    user_data["api_key"]: username
    for username, user_data in users.items()
}


def get_user_by_api_key(api_key: str) -> Optional[Dict]:
    """
    Retrieve a user by their API key.
    
    Args:
        api_key: The API key to look up
        
    Returns:
        The user data dictionary if found, None otherwise
    """
    if api_key not in api_key_to_user:
        return None
    
    username = api_key_to_user[api_key]
    return {
        "username": username,
        **users[username]
    }


def validate_api_key(api_key: str) -> bool:
    """
    Check if an API key is valid.
    
    Args:
        api_key: The API key to validate
        
    Returns:
        True if the API key exists, False otherwise
    """
    return api_key in api_key_to_user 