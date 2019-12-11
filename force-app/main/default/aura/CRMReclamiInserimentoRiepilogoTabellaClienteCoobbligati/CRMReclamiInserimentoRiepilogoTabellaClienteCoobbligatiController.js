({
	init:function(cmp,event,helper){
		helper.buildTableColumns(cmp);
        var list=[];
        console.log('Init_coobblig');
        var cliente=cmp.get('v.clienteSelezionato');
        if(cliente)
        	cliente['tipoCliente']='Cliente';
        var codCli = cliente.codCliente;             
                    
        list.push(cliente);
        var pratica=cmp.get('v.praticaSelezionata');
        console.log('Init_coobblig_Prat: '+pratica);
        console.log(pratica);
        var coobList=[];
        if(pratica){
             coobList=pratica['elencoCoobbligati']?pratica['elencoCoobbligati']:[];
            console.log('Init_coobblig_list'+coobList);
        }
        coobList.forEach(function(temp){
            console.log('cooblist :'+ temp);
            console.log(temp);
            temp['tipoCliente']='Coobbligato';
            if(temp.codCliente != codCli)
            	list.push(temp);
        });
        cmp.set('v.listaClienteCoobbligati',list);
	}
})