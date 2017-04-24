# llvmstdc-PrettyPrinter-for-GDB

This is gdb user-define function set for debugging STL of llvm stdc++ version.

I found this one(https://github.com/koutheir/libcxx-pretty-printers) but my gdb doesn't support python yet.

So I made it and the usage comes from https://gist.github.com/skyscribe/3978082

It's simple to use as shown below.

It supports std::string, std::vector, std::map, std::multimap, std::unordered_map, std::list, std::stack, std::deque, std::queue.
  
    // Test Code
    std::vector<int32_t> intVec;
    std::map<std::string, int32_t> siMap;
    std::map<int32_t, int32_t> iiMap;
    std::multimap<std::string, int32_t> siMMap;
    std::multimap<int32_t, int32_t> iiMMap;
    std::unordered_map<std::string, int32_t> siHMap;
    std::unordered_map<int32_t, int32_t> iiHMap;
    std::list<int32_t> intList;
    std::stack<int32_t> intStack;
    std::deque<int32_t> intDeque;
    std::queue<int32_t> intQueue;
 
    for (int i = 10; i > 0; i--) {
        intVec.push_back(i);
 
        siMap[std::to_string(i)] = i;
        iiMap[i] = i;
 
        siMMap.insert(std::pair<std::string, int32_t>(std::to_string(i), i));
        siMMap.insert(std::pair<std::string, int32_t>(std::to_string(10-i), 10-i));
 
        iiMMap.insert(std::pair<int32_t, int32_t>(i, i));
        iiMMap.insert(std::pair<int32_t, int32_t>(10-i, 10-i));
 
        siHMap[std::to_string(i)] = i;
        iiHMap[i] = i;
 
        intList.push_back(i);
 
        intStack.push(i);
 
        intDeque.push_back(i);
        intDeque.push_front(i);
 
        intQueue.push(i);
    }
    
    // iterating vector
    (gdb) pvector intVec
    [0]: $3 = 10
    [1]: $4 = 9
    [2]: $5 = 8
    [3]: $6 = 7
    [4]: $7 = 6
    [5]: $8 = 5
    [6]: $9 = 4
    [7]: $10 = 3
    [8]: $11 = 2
    [9]: $12 = 1
    Size = 10

    // Printing specific element of vector
    (gdb) pvector intVec 3
    [3]: $116 = 7
    Size = 10

    // Printing specific range of vector
    (gdb) pVector intVec 0 9
    [0]: $117 = 10
    [1]: $118 = 9
    [2]: $119 = 8
    [3]: $120 = 7
    [4]: $121 = 6
    [5]: $122 = 5
    [6]: $123 = 4
    [7]: $124 = 3
    [8]: $125 = 2
    [9]: $126 = 1
    Size = 10

    // iterating list
    (gdb) plist intList
    [0]: $239 = 10
    [1]: $240 = 9
    [2]: $241 = 8
    [3]: $242 = 7
    [4]: $243 = 6
    [5]: $244 = 5
    [6]: $245 = 4
    [7]: $246 = 3
    [8]: $247 = 2
    [9]: $248 = 1
    Size = 10

    // iterating stack
    (gdb) pstack intStack
    [0]$249 = 10
    [1]$250 = 9
    [2]$251 = 8
    [3]$252 = 7
    [4]$253 = 6
    [5]$254 = 5
    [6]$255 = 4
    [7]$256 = 3
    [8]$257 = 2
    [9]$258 = 1
    Size = 10

    // iterating deque
    (gdb) pdequeue intDeque
    [0]$259 = 1
    [1]$260 = 2
    [2]$261 = 3
    [3]$262 = 4
    [4]$263 = 5
    [5]$264 = 6
    [6]$265 = 7
    [7]$266 = 8
    [8]$267 = 9
    [9]$268 = 10
    [10]$269 = 10
    [11]$270 = 9
    [12]$271 = 8
    [13]$272 = 7
    [14]$273 = 6
    [15]$274 = 5
    [16]$275 = 4
    [17]$276 = 3
    [18]$277 = 2
    [19]$278 = 1
    Size = 20

    // iterating queue
    (gdb) pqueue intQueue
    [0]$279 = 10
    [1]$280 = 9
    [2]$281 = 8
    [3]$282 = 7
    [4]$283 = 6
    [5]$284 = 5
    [6]$285 = 4
    [7]$286 = 3
    [8]$287 = 2
    [9]$288 = 1
    Size = 10

    // Printing string
    // if it is sso(short string optimization) then prints all elements of array.
    // and didn't find printing as heap allocated string. :(
    (gdb) pstring sso_string
    $238 = "test~\000\000\000\000\000"
    (gdb) pstring long_string
    "10987654321"
    (gdb)

    // iterating std::map and the key type is std::string (which is sso)
    (gdb) psmap siMap
    [0] Key ::$217 = "1\000\000\000\000\000\000\000\000\000"
    [0] Value ::$218 = 1
    [1] Key ::$219 = "10\000\000\000\000\000\000\000\000"
    [1] Value ::$220 = 10
    [2] Key ::$221 = "2\000\000\000\000\000\000\000\000\000"
    [2] Value ::$222 = 2
    [3] Key ::$223 = "3\000\000\000\000\000\000\000\000\000"
    [3] Value ::$224 = 3
    [4] Key ::$225 = "4\000\000\000\000\000\000\000\000\000"
    [4] Value ::$226 = 4
    [5] Key ::$227 = "5\000\000\000\000\000\000\000\000\000"
    [5] Value ::$228 = 5
    [6] Key ::$229 = "6\000\000\000\000\000\000\000\000\000"
    [6] Value ::$230 = 6
    [7] Key ::$231 = "7\000\000\000\000\000\000\000\000\000"
    [7] Value ::$232 = 7
    [8] Key ::$233 = "8\000\000\000\000\000\000\000\000\000"
    [8] Value ::$234 = 8
    [9] Key ::$235 = "9\000\000\000\000\000\000\000\000\000"
    [9] Value ::$236 = 9
    Size = 10

    // iterating std::map
    (gdb) pmap iiMap
    [0] Key :: $177 = 1
    [0] Value :: $178 = 1
    [1] Key :: $179 = 2
    [1] Value :: $180 = 2
    [2] Key :: $181 = 3
    [2] Value :: $182 = 3
    [3] Key :: $183 = 4
    [3] Value :: $184 = 4
    [4] Key :: $185 = 5
    [4] Value :: $186 = 5
    [5] Key :: $187 = 6
    [5] Value :: $188 = 6
    [6] Key :: $189 = 7
    [6] Value :: $190 = 7
    [7] Key :: $191 = 8
    [7] Value :: $192 = 8
    [8] Key :: $193 = 9
    [8] Value :: $194 = 9
    [9] Key :: $195 = 10
    [9] Value :: $196 = 10
    Size = 10

    // iterating std::multimap
    (gdb) pmap iiMMap
    [0] Key :: $2 = 0
    [0] Value :: $3 = 0
    [1] Key :: $4 = 1
    [1] Value :: $5 = 1
    [2] Key :: $6 = 1
    [2] Value :: $7 = 1
    [3] Key :: $8 = 2
    [3] Value :: $9 = 2
    [4] Key :: $10 = 2
    [4] Value :: $11 = 2
    [5] Key :: $12 = 3
    [5] Value :: $13 = 3
    [6] Key :: $14 = 3
    [6] Value :: $15 = 3
    [7] Key :: $16 = 4
    [7] Value :: $17 = 4
    [8] Key :: $18 = 4
    [8] Value :: $19 = 4
    [9] Key :: $20 = 5
    [9] Value :: $21 = 5
    [10] Key :: $22 = 5
    [10] Value :: $23 = 5
    [11] Key :: $24 = 6
    [11] Value :: $25 = 6
    [12] Key :: $26 = 6
    [12] Value :: $27 = 6
    [13] Key :: $28 = 7
    [13] Value :: $29 = 7
    [14] Key :: $30 = 7
    [14] Value :: $31 = 7
    [15] Key :: $32 = 8
    [15] Value :: $33 = 8
    [16] Key :: $34 = 8
    [16] Value :: $35 = 8
    [17] Key :: $36 = 9
    [17] Value :: $37 = 9
    [18] Key :: $38 = 9
    [18] Value :: $39 = 9
    [19] Key :: $40 = 10
    [19] Value :: $41 = 10
    Map size = 20

    // iterating std::multimap and the key type is std::string
    (gdb) psmap siMMap
    [0] Key ::$44 = "0\000\000\000\000\000\000\000\000\000"
    [0] Value ::$45 = 0
    [1] Key ::$46 = "1\000\000\000\000\000\000\000\000\000"
    [1] Value ::$47 = 1
    [2] Key ::$48 = "1\000\000\000\000\000\000\000\000\000"
    [2] Value ::$49 = 1
    [3] Key ::$50 = "10\000\000\000\000\000\000\000\000"
    [3] Value ::$51 = 10
    [4] Key ::$52 = "2\000\000\000\000\000\000\000\000\000"
    [4] Value ::$53 = 2
    [5] Key ::$54 = "2\000\000\000\000\000\000\000\000\000"
    [5] Value ::$55 = 2
    [6] Key ::$56 = "3\000\000\000\000\000\000\000\000\000"
    [6] Value ::$57 = 3
    [7] Key ::$58 = "3\000\000\000\000\000\000\000\000\000"
    [7] Value ::$59 = 3
    [8] Key ::$60 = "4\000\000\000\000\000\000\000\000\000"
    [8] Value ::$61 = 4
    [9] Key ::$62 = "4\000\000\000\000\000\000\000\000\000"
    [9] Value ::$63 = 4
    [10] Key ::$64 = "5\000\000\000\000\000\000\000\000\000"
    [10] Value ::$65 = 5
    [11] Key ::$66 = "5\000\000\000\000\000\000\000\000\000"
    [11] Value ::$67 = 5
    [12] Key ::$68 = "6\000\000\000\000\000\000\000\000\000"
    [12] Value ::$69 = 6
    [13] Key ::$70 = "6\000\000\000\000\000\000\000\000\000"
    [13] Value ::$71 = 6
    [14] Key ::$72 = "7\000\000\000\000\000\000\000\000\000"
    [14] Value ::$73 = 7
    [15] Key ::$74 = "7\000\000\000\000\000\000\000\000\000"
    [15] Value ::$75 = 7
    [16] Key ::$76 = "8\000\000\000\000\000\000\000\000\000"
    [16] Value ::$77 = 8
    [17] Key ::$78 = "8\000\000\000\000\000\000\000\000\000"
    [17] Value ::$79 = 8
    [18] Key ::$80 = "9\000\000\000\000\000\000\000\000\000"
    [18] Value ::$81 = 9
    [19] Key ::$82 = "9\000\000\000\000\000\000\000\000\000"
    [19] Value ::$83 = 9
    Map size = 20

    // iterating std::unordered_map
    (gdb) phmap iiHMap
    Key :: $218 = 1
    Value :: $219 = 1
    Key :: $220 = 2
    Value :: $221 = 2
    Key :: $222 = 3
    Value :: $223 = 3
    Key :: $224 = 4
    Value :: $225 = 4
    Key :: $226 = 5
    Value :: $227 = 5
    Key :: $228 = 6
    Value :: $229 = 6
    Key :: $230 = 7
    Value :: $231 = 7
    Key :: $232 = 8
    Value :: $233 = 8
    Key :: $234 = 9
    Value :: $235 = 9
    Key :: $236 = 10
    Value :: $237 = 10
    Size : 10

    // std::unordered_map and the key type is std::string
    (gdb) phsmap siHMap
    Key :: $238 = "1\000\000\000\000\000\000\000\000\000"
    Value :: $239 = 1
    Key :: $240 = "2\000\000\000\000\000\000\000\000\000"
    Value :: $241 = 2
    Key :: $242 = "3\000\000\000\000\000\000\000\000\000"
    Value :: $243 = 3
    Key :: $244 = "5\000\000\000\000\000\000\000\000\000"
    Value :: $245 = 5
    Key :: $246 = "9\000\000\000\000\000\000\000\000\000"
    Value :: $247 = 9
    Key :: $248 = "7\000\000\000\000\000\000\000\000\000"
    Value :: $249 = 7
    Key :: $250 = "6\000\000\000\000\000\000\000\000\000"
    Value :: $251 = 6
    Key :: $252 = "4\000\000\000\000\000\000\000\000\000"
    Value :: $253 = 4
    Key :: $254 = "8\000\000\000\000\000\000\000\000\000"
    Value :: $255 = 8
    Key :: $256 = "10\000\000\000\000\000\000\000\000"
    Value :: $257 = 10
    Size : 10
