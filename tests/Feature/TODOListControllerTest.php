<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;
use App\Http\Controllers\TODOListController;
use App\Models\ListItem;

class TODOListControllerTest extends TestCase
{

    use RefreshDatabase;
    
    public function test_index(){

        $response = $this->get("/");
        // print(json_encode($response));
        $response->assertStatus($response->status(),200);
    
    }
    public function test_saveItem(){

        $this->assertDatabaseCount('list_items',0);

        $response = $this->call("POST", route("saveItem"),[
            "text"=>"task 1"
        ]);
        
        $this->assertDatabaseCount('list_items',1); // Check if item is added to the database
        $this->assertEquals(ListItem::all()->first()->is_complete,0);  // to check if the status was is incomplete by default

        $this->assertEquals($response->status(),302);   // status code 302 means redirect

    }
    
    public function test_changeStatus_to_done(){

        $this->test_saveItem(); // add 1 item

        $response = $this->call("POST", route("changeStatus",1),[
            "checked"=>"on"
        ]);

        $this->assertEquals(ListItem::all()->first()->is_complete,1);  // to check if the status was changed to completed

        $this->assertEquals($response->status(),302);   // status code 302 means redirect

    }

    public function test_changeStatus_to_not_done(){

        $this->test_changeStatus_to_done(); // get to the point where the status is done
        
        $response = $this->call("POST", route("changeStatus",1),[
        ]);

        $this->assertEquals(ListItem::all()->first()->is_complete,0);  // to check if the status was changed to incomplete

        $this->assertEquals($response->status(),302);   // status code 302 means redirect

    }

    public function test_deleteItem(){

        $this->test_saveItem(); // create an item
        $response = $this->call("POST",route("deleteItem"),[
            'id'=>"1",
        ]);

        $this->assertDatabaseCount("list_items",0);  // check if the item is deleted
        $this->assertEquals($response->status(),302);   // status code 302 means redirect
    }
}
