      print()
      function skrubba(lista)
        for _,item in ipairs(lista) do
          item[4] = {item[4].end_col, item[4].end_row}
        end
        return lista
      end
      print(id1, vim.inspect(skrubba(meths.buf_get_extmarks(0, id1, 0, -1, {details=true}))))
      print(id2, vim.inspect(skrubba(meths.buf_get_extmarks(0, id2, 0, -1, {details=true}))))
      io.stdout:flush()

      function skrubba(lista)
        for _,item in ipairs(lista) do
          item[4].right_gravity = nil
          item[4].ns_id = nil
          setmetatable(item[4], nil)
        end
        return lista
      end

-- IGEN:
      local rekna = 0
      function begå()
        rekna = rekna + 1
        print("\n\n"..rekna)
        function skrubba(lista)
          for _,item in ipairs(lista) do
            item[4] = {item[4].end_col, item[4].end_row}
          end
          return lista
        end
        print(id1, vim.inspect(skrubba(meths.buf_get_extmarks(0, id1, 0, -1, {details=true}))))
        print(id2, vim.inspect(skrubba(meths.buf_get_extmarks(0, id2, 0, -1, {details=true}))))
        io.stdout:flush()
      end
      begå()

        if false and ival == 201 then
          local str1 = lib.mt_inspect(tree, true, true)
          local dot1 = ffi.string(str1.data, str1.size)
          local forfil = io.open("Xforfile.dot", "wb")
          forfil:write(dot1)
          forfil:close()
          print("forfil")io.stdout:flush()
        end
