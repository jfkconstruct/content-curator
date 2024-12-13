from typing import Dict, Any, List
import openai
import os
from ..utils.supabase_client import supabase

class ContentProcessor:
    def __init__(self):
        openai.api_key = os.getenv("OPENAI_API_KEY")

    async def analyze_content(self, content: str) -> Dict[str, Any]:
        """Analyze content using OpenAI API"""
        try:
            response = await openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": "Analyze the following content and extract key information."},
                    {"role": "user", "content": content}
                ]
            )
            
            # Process the response to extract insights
            analysis = {
                "summary": response.choices[0].message.content,
                "sentiment": self._analyze_sentiment(content),
                "keywords": self._extract_keywords(content)
            }
            
            return analysis
        except Exception as e:
            print(f"Error analyzing content: {str(e)}")
            return None

    def _analyze_sentiment(self, content: str) -> str:
        """Basic sentiment analysis"""
        # Implement basic sentiment analysis logic
        # This is a placeholder - you might want to use a proper NLP library
        positive_words = ['good', 'great', 'excellent', 'amazing']
        negative_words = ['bad', 'poor', 'terrible', 'awful']
        
        content_lower = content.lower()
        positive_count = sum(1 for word in positive_words if word in content_lower)
        negative_count = sum(1 for word in negative_words if word in content_lower)
        
        if positive_count > negative_count:
            return "positive"
        elif negative_count > positive_count:
            return "negative"
        return "neutral"

    def _extract_keywords(self, content: str) -> List[str]:
        """Extract keywords from content"""
        # This is a basic implementation
        # Consider using proper keyword extraction libraries
        words = content.lower().split()
        # Remove common words (stop words)
        stop_words = {'the', 'is', 'at', 'which', 'on', 'a', 'an', 'and', 'or'}
        keywords = [word for word in words if word not in stop_words]
        return list(set(keywords))[:10]  # Return top 10 unique keywords

    async def store_analysis(self, content_id: str, analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Store content analysis in Supabase"""
        data = {
            "content_id": content_id,
            "analysis": analysis
        }
        result = supabase.table('content_analysis').insert(data).execute()
        return result.data[0] if result.data else None
