# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

#
# @author Daniel Kuppitz (http://gremlin.guru)
#
BEGIN {
  lang = null
  inCodeBlock = 0
}

/^\[source,/ {
  delimiter = 1
  split($0, a, ",")
  lang = gensub(/]$/, "", 1, a[2])
}

/^----$/ {
  if (inCodeBlock == 0) inCodeBlock = 1
  else inCodeBlock = 0
}

{ if (inCodeBlock) {
    switch (lang) {
      case "python":
        gsub(/^gremlin>/, ">>>")
        gsub(/^==>/, "")
        $0 = gensub(/processTraversal\("""(.*)"""\, jython, groovy)/, "\\1", 1)
        $0 = gensub("g\\.V\\(([^\\)]+)", "g.V(Bindings\\.of('id',\\1)", "g")
        print gensub("g\\.V\\(Bindings.of\\('id',(Bindings.of\\([^\\)]+\\))\\)\\)", "g.V(\\1)", "g")
        break
      default:
        print
        break
    }
  } else print
}
