#!/usr/bin/env python3
"""
Working with reddis
"""
import redis
import uuid
from functools import wraps
from typing import Union, Callable, Any


def call_history(method: Callable) -> Callable:
    """
    Checking and making a list of the call history
    """
    @wraps(method)
    def wrapper(self, *args, **kwargs) -> Any:
        """
        Wrapper function that stores inputs and outputs
        """
        key_prefix = method.__qualname__
        inputs_key = f"{key_prefix}:inputs"
        outpus_key = f"{key_prefix}:outputs"

        self._redis_rpush(inputs_key, str(args))

        output = method(self, *args, **kwargs)

        self._redis.rpush(outputs_key, output)

        return output

    return wrapper


def count_calls(method: Callable) -> Callable:
    """
    Fixing in a decorator
    """
    @wraps(method)
    def wrapper(self, *args, **kwargs):
        """
        The wrapper function
        """
        key = method.__qualname__
        self._redis.incr(key)
        return method(self, *args, *kwargs)
    return wrapper


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



    @count_calls
    @call_history
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


    def get(self, key: str, fn: Callable = None) -> Union[bytes, str, int, None]:
        """
        Convert data back to the desired format
        """
        data = self._redis.get(key)

        if data is None:
            return None
        if fn is not None:
            return fn(data)
        return data


    def get_str(self, key: str) -> str:
        """
        Parametrize the cache get
        """
        return self.get(key, fn=lambda d: d.decode("utf-8"))


    def get_int(self, key: str) -> int:
        """
        Parametrize the cache get
        """
        return self.get(key, fn=int)
