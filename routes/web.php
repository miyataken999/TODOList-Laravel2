<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TODOListController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/',
[TODOListController::class,"index"]
);

Route::post('/saveItem',
[TODOListController::class,"saveItem"]
)->name("saveItem");

Route::post('/changeStatus/{id}',
[TODOListController::class,"changeStatus"]
)->name("changeStatus");


Route::post("/deleteItem",
[TODOListController::class,'deleteItem']
)->name("deleteItem");