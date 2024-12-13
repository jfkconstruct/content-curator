from supabase import create_client
import os
from dotenv import load_dotenv

load_dotenv()

def get_supabase_client():
    supabase_url = os.getenv("SUPABASE_URL")
    supabase_key = os.getenv("SUPABASE_KEY")
    
    if not supabase_url or not supabase_key:
        raise ValueError("Supabase credentials not found in environment variables")
    
    return create_client(supabase_url, supabase_key)

# Initialize client
supabase = get_supabase_client()
