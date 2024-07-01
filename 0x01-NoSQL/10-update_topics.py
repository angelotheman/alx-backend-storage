#!/usr/bin/env python3
"""
Update the topics
"""


def update_topics(mongo_collection, name, topics):
    """
    Change school topics
    """
    mongo_collection.update_many(
            {'name': name},
            {'$set': {'topics': topics}}
    )
