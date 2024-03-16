# -*- coding: utf-8 -*-
# distutils: language=c++
# cython: language_level=3

"""
DBO Module:
Map from DB Responses to Python objects
"""

from typing import Any, Dict, Optional

from dataclasses import dataclass
from typeguard import typechecked

@typechecked
@dataclass
class User:
    """
    Botze-specific User data
    """

    user_id            :int
    name               :str
    invite_count       :int # not used
    unclaimed_codes    :int # not used
    used_invites       :int # not used

    @staticmethod
    def from_response(data:Dict[str,Any]) -> 'User':
        """ constructor """

        user_id        :int           = data['id']
        name           :str           = data['name']
        invite_count   :int           = data['invite_count']
        unclaimed_codes:int           = data['unclaimed_codes']
        used_invites   :int           = data['used_invites']
        return User(user_id, name, invite_count, unclaimed_codes, used_invites)

@typechecked
@dataclass
class Game:
    """
    Botze-specific Game data
    """

    game_id            :int
    name               :str
    url                :str # url to where this game is hosted ; not used ?
    description        :str # description of this game ; not used ?
    image              :Optional[str] # url to icon for this game ; not used ?

    @staticmethod
    def from_response(data:Dict[str,Any]) -> 'Game':
        """ constructor """

        game_id        :int           = data['id']
        name           :str           = data['name']
        url            :str           = data['url']
        description    :str           = data['description']
        image          :Optional[str] = data['image']
        return Game(game_id, name, url, description, image)

@typechecked
@dataclass
class Code:
    """
    User- and Game-specific Access Code
    """

    user_id            :int
    game_id            :int
    remaining          :int
    secret             :str

    @staticmethod
    def from_response(data:Dict[str,Any]) -> 'Code':
        """ constructor """

        user_id        :int           = data['user_id']
        game_id        :int           = data['game_id']
        remaining      :int           = data['remaining']
        secret         :str           = data['secret']
        return Code(user_id, game_id, remaining, secret)

@typechecked
@dataclass
class Badge: # not used
    """ Botze-specific Accomplishments """

    badge_id           :int
    badge_name         :str

    @staticmethod
    def from_response(data:Dict[str,Any]) -> 'Badge':
        """ constructor """

        badge_id       :int           = data['id']
        badge_name     :str           = data['name']
        return Badge(badge_id, badge_name)

@typechecked
@dataclass
class UserBadgeLink: # not used
    """ User-Badge Granting """

    user_id            :int
    badge_id           :int

    @staticmethod
    def from_response(data:Dict[str,Any]) -> 'UserBadgeLink':
        """ constructor """

        user_id        :int           = data['user_id']
        badge_id       :int           = data['badge_id']
        return UserBadgeLink(user_id, badge_id)

__author__    :str = "YouChat"
__copyright__ :str = "Copyright 2024, InnovAnon, Inc."
__license__   :str = "Proprietary"
__version__   :str = "1.0"
__maintainer__:str = "@lmaddox"
__email__     :str = "InnovAnon-Inc@gmx.com"
__status__    :str = "Production"
