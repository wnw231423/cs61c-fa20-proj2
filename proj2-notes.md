Some side notes here:
1. In unittest, use `t.execute(code=78)` to check if program exit with specific error. I learned it by reading fa24's unittest.py file.(https://github.com/61c-teach/fa24-proj2-starter/blob/main/unittests.py).
2. Bad experience when doing `write matrix`:
    1. IDK the buffer can only be heap area so I directly do fread, passing the pointer of `rows` and `cols` to it, which cause errors.
    2. IDK the output only contains elements of the matrix but not the "meta-data" like rows and cols so I return something like [2(rows), 2(cols), 1, 2, 3, 4], which cause errors.
    3. I realizing that I was doing the wrong thing. Thus I became nervous and I forget "slli 2" when malloc, which makes me even sadder.
   Hard as they were, tomorrow is another day :) 
3. Little summary:
    1. Handle exceptions: if the exception can be directly detected by arguments, we can do it before prologue. If the exception needs other functions to be detected, do it after prologue.
    2. Prologue.
    3. Malloc, DO remember allocate numOfElements * sizeOfElements space. Even though it's easy, I still ocassionally forget it.
    4. Passing parameters. The most complex part is passing a pointer of an array. Normally you need 3 steps to get the pointer:
        1. Get the index.
        2. use `slli` to get the offset.
        3. use `add` to get the exact pointer value.
    5. Free malloc.
    6. Episode.
