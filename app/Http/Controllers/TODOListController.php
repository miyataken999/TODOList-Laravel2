<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\ListItem;

class TODOListController extends Controller
{
    //
    public function index(){
        return view('welcome',["listitems"=>ListItem::orderBy('is_complete')->orderBy("created_at","DESC")->get()]);
    }
    public function saveItem(Request $request){
        // \Log::info(json_encode($request->all()));
        $listitem = new ListItem();
        $listitem->name = $request['text'];
        $listitem->is_complete = 0;
        $listitem->save();

        return redirect("/");
    }

    public function changeStatus($id,Request $request){
        $listitem = ListItem::where("id",$id)->first();
        
        $listitem->is_complete = 0; // by default make it incompleted
        
        if(isset($request->checked)){
            $listitem->is_complete = 1; // task completed
        }
        $listitem->save();

        return redirect("/");
    }
    
    public function deleteItem(Request $request){
        // \Log::info(json_encode($request->all()));
        $listitem = ListItem::where("id",$request->id)->first();
        // \Log::info(json_encode($listitem));
        $listitem->delete();
        return redirect("/");
    }
}
