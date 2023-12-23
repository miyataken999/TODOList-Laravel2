<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>TODO List</title>

        <!-- Fonts -->
        <link rel="preconnect" href="https://fonts.bunny.net">
        <link href="https://fonts.bunny.net/css?family=figtree:400,600&display=swap" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link href="{{ asset('css/style.css') }}" rel="stylesheet">
        <!-- <link href="css/style.css" rel="stylesheet"> -->
    </head>
    <body>
        <div class="main_container">
            
            <h2 class="title">TODO List</h2>
            <form class="input_container" method="POST" action="{{ route('saveItem') }}">
                {{ csrf_field() }}
                <input type="text" name="text" placeholder="Task 1" required>
                <input type="submit" value="create">
            </form>
            <div id="list_container">
                @foreach ($listitems as $item)
                <form class='item' method="POST" action="{{ route('changeStatus',$item['id']) }}" data-id="{{ $item['id'] }}">
                    {{ csrf_field() }}
                    
                    {{ $item['name'] }}
                    <div class="btn_container">
                        <input class='check_btn' type='checkbox' name="checked" onchange="this.form.submit()" 
                        @if ($item['is_complete'] === 1)
                        checked
                        @endif
                        >
                        <i class="fa-solid fa-trash delete_btn" onclick="delete_item(this.closest('.item'));"></i>
                    </div>
                </form>
                @endforeach
            </div>
        </div>
        <script>
            var csrf_token = "{{ csrf_token() }}";
            var deleteItem = "{{ route('deleteItem') }}";
        </script>
        <script src="{{ asset('js/script.js') }}">
        </script>
    </body>
</html>
