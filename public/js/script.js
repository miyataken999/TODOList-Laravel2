function delete_item(elem){
    result = confirm("Do you really wanna delete this ?");
    if(result==false) return;
    data = {"id":elem.dataset.id};
    fetch(deleteItem,{
        method:"POST",
        headers:{
            "content-type":"application/json",
            "X-CSRF-TOKEN":csrf_token,
        },
        body:JSON.stringify(data)
    }).then(res=>res).then((res)=>{
        elem.remove();
    });
}