require("TransFun")

--Ӧ�ó����ʼ�������
function on_sys_init()
	--����Ŀ¼��
	for i , n in ipairs(GenFile) do
		--se_trace(n.subdir .. ':' .. n.name);
		se_tree_addnode(n.subdir,n.name);
	end

	--����List�ؼ�
	se_list_addcol("Excel",200);
	se_list_addcol("Sheet",200);
	return 1;
end

--�����ѡ��ʱ�����
function on_node_select(item)
	for _ , n in ipairs(GenFile) do
		if n.name == item then
			se_list_clear();
			for _ , it in ipairs(n.step) do
				local row = se_list_addrow();
				se_list_setrow(row,0,it.excel);
				se_list_setrow(row,1,it.sheet);
			end
		end
	end
	return 1;
end

--Sheet��ѡ��ʱ����
function on_seet_select(index)
	--se_trace("select" .. index);
	return 1;
end

--�����ʼ���ɰ�ť
function on_click_btnstart()
end

--�����̵߳���
function on_work(...)
	se_trace("ת���߳�����");
	for _ , v in ipairs(arg) do
		for _ , n in ipairs(GenFile) do
			if n.name == v then
				if type_fun[n.type](n) == 0 then

				end
			end
		end
	end
	return 1;
end
