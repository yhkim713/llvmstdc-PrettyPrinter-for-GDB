#
# std::vector<>
#
define pvector
	if $argc == 0
		help pvector
	else
		set $size = $arg0.__end_ - $arg0.__begin_
		set $size_max = $size - 1
	end

	if $argc == 1
		set $i = 0
		while $i < $size
			printf "[%u]: ", $i
			p *($arg0.__begin_ + $i)
			set $i++
		end
	end

	if $argc == 2
		set $idx = $arg1
		if $idx < 0 || $idx > $size_max
			printf "[%d] is not in acceptable range: [0..%u].\n", $idx, $size_max
		else
			printf "[%u]: ", $idx
			p *($arg0.__begin_ + $idx)
		end
	end

	if $argc == 3
	  set $start_idx = $arg1
	  set $stop_idx = $arg2
	  
	  if $start_idx > $stop_idx
	    set $tmp_idx = $start_idx
	    set $start_idx = $stop_idx
	    set $stop_idx = $tmp_idx
	  end

	  if $start_idx < 0 || $stop_idx < 0 || $start_idx > $size_max || $stop_idx > $size_max
	    printf "[%d,%d] are not in acceptable range: [0..%u].\n", $start_idx, $stop_idx, $size_max
	  else
	    set $i = $start_idx
		while $i <= $stop_idx
			printf "[%u]: ", $i
			p *($arg0.__begin_ + $i)
			set $i++
		end
	  end
	end
	
	if $argc > 0
		printf "Size = %u\n", $size
	end
end

document pvector
	Prints std::vector<T> information.
	Syntax:
 	 pvector v - prints vector content and size
	 pvector v n - prints only nth element of vector
	 pvector v r1 r2 - prints elements in range [r1~r2]
end

#
# std::list<>
#
define plist
	if $argc == 0
		help plist
	else
		set $end = &$arg0.__end_
		set $current = $arg0.__end_.__next_
		set $size = 0
		
		while $current != $end
			if $argc == 1
				printf "[%u]: ", $size
				p $current.__value_
			end
			
			if $argc == 2
				if $size == $arg1
					printf "[%u]: ", $size
					p $current.__value_
				end
			end
			
			set $current = $current.__next_
			set $size++
		end
		
		printf "Size = %u \n", $size
	end
end

document plist
    Prints std::list<T> information.
    Syntax:
     plist l - prints list size and its contents.
end

#
# std::map
#
define pmap
	if $argc == 0
		help pmap
	end
	
	if $argc > 0
	    set $tree = $arg0
	    set $i = 0
	    set $node = $tree.__tree_.__begin_node_
	    set $casting_type = $tree.__tree_.__begin_node_
	    set $end = $tree.__tree_.__pair1_.__first_
	    set $tree_size = $tree.__tree_.__pair3_.__first_
	
	    if $argc == 1
		    while $i < $tree_size
		        set $value = (typeof($casting_type))$node
		        set $first = $value.__value_.__cc.first
		        set $second = $value.__value_.__cc.second
		        
			    printf "[%u] Key :: ", $i
			    p $first
			
			    printf "[%u] Value :: ", $i
			    p $second
			
			    if $node.__right_ != 0
				    set $node = $node.__right_
				    while $node.__left_ != 0
					    set $node = $node.__left_
				    end
			    else
				    set $tmp_node = $node.__parent_
				    while $node == $tmp_node.__right_
					    set $node = $tmp_node
					    set $tmp_node = $tmp_node.__parent_
				    end
				    if $node.__right_ != $tmp_node
					    set $node = $tmp_node
				    end
			    end
			
			    set $i++
		    end
		
	        printf "Size = %u\n", $tree_size
	    end
	end
end

document pmap
	Prints std::map<key, value> information.
	Syntax:
	 pmap m - prints map size and its contents.
end

#
# std::string
#
define pstring
    if $argc == 0
        help pstring
    else
        set $string = $arg0
        set $short_mask = 'std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char>>::__short_mask'
        set $is_long = $string.__r_.__first_.__s.__size_ & $short_mask
        
        if $is_long == 0
            # short string optimization
            # gdb shows error "Attempt to take address of value not located in memory" with printf
            # due to that issue, it just prints with p, not printf
            p $string.__r_.__first_.__s.__data_
        else
            # this string is long
            printf "\"%s\"\n", $string.__r_.__first_.__l.__data_
        end
    end
end

document pstring
    Prints std::string information.
    Syntax: 
     pstring s - prints string
end

#
# std::map (The key is std::string only)
#
define psmap
	if $argc == 0
		help psmap
	else
		set $tree = $arg0
		set $i = 0
		set $node = $tree.__tree_.__begin_node_
		set $casting_type = $tree.__tree_.__begin_node_
		set $end = $tree.__tree_.__pair1_.__first_
		set $tree_size = $tree.__tree_.__pair3_.__first_
		
		if $argc == 0
			printf "String Map "
			whatis $tree
			printf "Use psmap <variable_name> to see the elements in the map.\n"
		end

		if $argc == 1
			while $i < $tree_size
			    set $value = (typeof($casting_type))$node
			    set $first = $value.__value_.__cc.first
			    set $second = $value.__value_.__cc.second
                printf "[%u] Key ::", $i
				pstring $first
                printf "[%u] Value ::", $i
				p $second

				if $node.__right_ != 0
					set $node = $node.__right_
					while $node.__left_ != 0
						set $node = $node.__left_
					end
				else
					set $tmp_node = $node.__parent_
					while $node == $tmp_node.__right_
						set $node = $tmp_node
						set $tmp_node = $tmp_node.__parent_
					end
					if $node.__right_ != $tmp_node
						set $node = $tmp_node
					end
				end
				
				set $i++
			end
		end
		printf "Size = %u\n", $tree_size
	end
end

document psmap
	Prints std::map<std::string, T> information.
	Syntax:
	 pmap m - prints map size and definition
end

#
# std::unordered_map
#
define phmap
    if $argc == 0
        help phmap
    else
        set $node = $arg0.__table_.__p1_.__first_.__next_
        set $size = $arg0.__table_.__p2_.__first_

        while $node != 0
            printf "Key :: "
            p $node.__value_.__cc.first
            printf "Value :: "
            p $node.__value_.__cc.second
            
            set $node = $node.__next_
        end
        
        printf "Size : %u\n", $size
    end
end

document phmap
    Prints std::unordered_map<T, T> information.
    Syntax:
     phmap m - prints map size and definition
end

define phsmap
    if $argc == 0
        help phsmap
    else
        set $node = $arg0.__table_.__p1_.__first_.__next_
        set $size = $arg0.__table_.__p2_.__first_
                
        while $node != 0
            printf "Key :: "
            pstring $node.__value_.__cc.first
            printf "Value :: "
            p $node.__value_.__cc.second
            
            set $node = $node.__next_
        end
        
        printf "Size : %u\n", $size
    end
end

document phsmap
    Prints std::unordered_map<std::string, T> informaion.
    Syntax:
     phsmap m - prints map size and definition
end

#
# std::dequeue
#
define pdequeue
	if $argc == 0
		help pdequeue
	else
		set $size = $arg0.__size_.__first_
		set $i = 0
		
		while $i < $size
		    set $idx = $arg0.__start_ + $i
		    set $p1 = *($arg0.__map_.__begin_ + $idx / $arg0.__block_size)
		    set $p2 = ($p1 + $idx % $arg0.__block_size)
		    
		    printf "[%u]", $i
		    p *($p2)
		    
		    set $i = $i + 1
		end
		
		printf "Size = %u\n", $size
	end
end

document pdequeue
	Prints std::dequeue<T> information.
	Syntax:
	 pdequeue d - prints all elements and size of d
end

#
# std::stack
#
define pstack
	if $argc == 0
		help pstack
	else
	    pdequeue $arg0.c 
	end
end

document pstack
	Prints std::stack<T> information.
	Syntax:
	 pstack s - prints all elements and the size of s
end

#
# std::queue
#
define pqueue
	if $argc == 0
		help pqueue
	else
	    pdequeue $arg0.c 
	end
end

document pqueue
	Prints std::queue<T> information.
	Syntax: 
	 pqueue q - prints all elements and the size of q
end

set print pretty on
set print object on
set print vtbl on
