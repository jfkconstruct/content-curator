import feedparser
import tweepy
import requests
from bs4 import BeautifulSoup
from typing import List, Dict, Any
import os
from ..utils.supabase_client import supabase

class ContentFetcher:
    def __init__(self):
        self.twitter_client = self._init_twitter_client()
    
    def _init_twitter_client(self) -> tweepy.Client:
        twitter_bearer_token = os.getenv("TWITTER_BEARER_TOKEN")
        if twitter_bearer_token:
            return tweepy.Client(bearer_token=twitter_bearer_token)
        return None

    async def fetch_rss(self, feed_url: str) -> List[Dict[str, Any]]:
        """Fetch and parse RSS feed content"""
        feed = feedparser.parse(feed_url)
        entries = []
        
        for entry in feed.entries:
            content = {
                "title": entry.get("title", ""),
                "content": entry.get("description", ""),
                "url": entry.get("link", ""),
                "published": entry.get("published", ""),
                "source_type": "rss",
                "source_url": feed_url
            }
            entries.append(content)
        
        return entries

    async def fetch_twitter(self, query: str, max_results: int = 10) -> List[Dict[str, Any]]:
        """Fetch tweets based on search query"""
        if not self.twitter_client:
            raise ValueError("Twitter client not initialized")
        
        tweets = []
        response = self.twitter_client.search_recent_tweets(
            query=query,
            max_results=max_results,
            tweet_fields=['created_at', 'text', 'author_id']
        )
        
        if response.data:
            for tweet in response.data:
                content = {
                    "content": tweet.text,
                    "created_at": tweet.created_at,
                    "source_type": "twitter",
                    "tweet_id": tweet.id,
                    "author_id": tweet.author_id
                }
                tweets.append(content)
        
        return tweets

    async def fetch_webpage(self, url: str) -> Dict[str, Any]:
        """Fetch and parse webpage content"""
        response = requests.get(url)
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Extract main content (this is a basic implementation)
        content = {
            "title": soup.title.string if soup.title else "",
            "content": soup.get_text(),
            "url": url,
            "source_type": "webpage"
        }
        
        return content

    async def store_content(self, content: Dict[str, Any]) -> Dict[str, Any]:
        """Store content in Supabase"""
        result = supabase.table('content').insert(content).execute()
        return result.data[0] if result.data else None
