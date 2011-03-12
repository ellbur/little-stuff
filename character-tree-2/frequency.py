# -*- coding: utf-8 -*-

import re

def get_most_frequent(texts, words, max_words):
    if len(words) <= max_words:
        return words
    
    return sorted(words, reverse = True, key = lambda word:
        count_all_occurrences_ci(texts, word)
    )[:max_words]

def count_all_occurrences_ci(texts, word):
    return sum(
        count_occurrences(text.lower(), word.lower()) > 0
        for
            text in texts
    )

def count_occurrences(text, word):
    return len(re.findall(
        r'\b{0}\b'.format(re.escape(word)), text
    ))

