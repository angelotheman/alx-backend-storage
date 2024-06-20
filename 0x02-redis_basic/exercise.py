#!/usr/bin/env python3
"""
Working with reddis
"""
import redis
import uuid
from  typing import Union


class Cache:
    """
    This is a class for the reddis database
    """
    def __init__(self):
        """
        Initialization method
        """
        self._redis = redis.Redis()
        self._redis.flushdb()


    def store(self, data: Union[str, bytes, int, float]) -> str:
        """
        Generates a random key and converts values to str
        if necessary
        """
        key = str(uuid.uuid4())

        if isinstance(data, (int, float)):
            data = str(data)

        self._redis.set(key, data)

        return key
