<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

use App\Models\ListItem;

class DatabaseTest extends TestCase
{
    use RefreshDatabase;

    public function test_data_added(): void
    {
        ListItem::factory()->count(3)->create();    // means that we are are creating 3 fake data
        // print(json_encode(ListItem::all()));
        $this->assertDatabaseCount('list_items',3);
    }

    public function test_data_removed(){
        ListItem::factory()->count(5)->create();
        $allitems = ListItem::all();

        for($i=0;$i<3;$i++){    //     delete 3 items
            $allitems[$i]->delete();
        }

        $this->assertDatabaseCount("list_items",2);
    }
}
