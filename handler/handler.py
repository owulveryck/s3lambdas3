#
# Copyright 2017 Alsanium, SAS. or its affiliates. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

import os
import json

import shim

def dump(obj):
    if hasattr(obj, '__slots__'):
        return {slot: getattr(obj, slot) for slot in obj.__slots__}
    return obj.__dict__

class Handler(object):
    def __getattr__(self, name):
        if name == "init":
            return lambda: None
        shim.lookup(name)
        return self._handle

    def _handle(self, evt, ctx):
        res = shim.handle(json.dumps(evt),
                          json.dumps(ctx, default=dump),
                          json.dumps(dict(**os.environ)),
                          ctx.get_remaining_time_in_millis)
        if res is not None:
            return json.loads(res)
