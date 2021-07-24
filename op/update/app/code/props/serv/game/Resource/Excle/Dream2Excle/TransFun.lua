require("tconfig")

--��key����ĸ�������
function pairsByKeys(t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0					-- iterator variable
	local iter = function ()		-- iterator function
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end

-- 0 ģʽת�� ��Normalģʽ ������ͨ��ini�ļ�
function trans_type0(item)

	local steps = item.step;
	--����Ϊ���򷵻�
	if table.getn(steps) <= 0 then
		se_trace( "steps Ϊ��" );
		return 0;
	end

	local tfile = {};
	local scount = 0;
	--���ζ�ȡÿ��sheet
	for _ , src in ipairs(steps) do
		local szexcel = se_transdir(ExcelPath .. '\\' .. src.excel);
		local szsheet = src.sheet;
		--��ʧ����ֱ�ӷ���

		if se_openexcel(szexcel,szsheet) ~= 1 then
			se_trace("ת��" .. src.excel .. ":" .. src.sheet .. "ʱ����");
			return 0;
		end

		se_trace("����" .. src.excel .. ":" .. src.sheet);
		local max_row = se_getmax_row();	--�������
		local max_col = se_getmax_col();	--�������
		if max_row <= 2 then
			--��ʾ��������
			se_trace("error".."Excel����̫��" .. src.excel .. ":" .. src.sheet);
			return 0;
		end

        --���ʱ�����ID�ֶ�
		local szid = se_getcell(2,1);
		if szid ~= "ID" then
		    se_trace("A2 ��Ԫ�������ID");
			return 0;
		end

		--�����û���ظ�ID
		local ct = {};
		for i = 3 , max_row do
			local sz = se_getcell(i,1);
			if sz ~= nil and sz ~= "" then
				if ct[sz] ~= nil then
				    se_trace("sheet" .. szsheet .. "�����ظ�ID" .. sz);
					return 0;
				else
				   ct[sz] = sz;
				end

			end
		end

		local col_msg = {};
		local col_count = 1;
		--��������Ϣ
		for c = 2 , max_col do
			local szcell = se_getcell(2,c);
			if szcell ~= nil and szcell ~= "" then
			    if col_msg[col_count] == nil then
					col_msg[col_count] = {};
				end
				col_msg[col_count].col = c;
				col_msg[col_count].text = szcell;
				col_count = col_count + 1;
			end
		end

		local cols = table.getn(col_msg); --ָ�����ɵ�������
		if  cols < 1 then
			--��ʾcols��Ϊ��
			se_trace("error".."Excel������û��" .. src.excel .. ":" .. src.sheet);
			return 0;
		end

		for i = 3 , max_row do
   			local section = se_getcell(i,1);
			if section ~= nil and section ~= "" then
			    if tfile[section] == nil then
					tfile[section] = {};
					tfile[section].section = "";
					tfile[section].property = {};
				end
				tfile[section].section = section;
				for j = 1 , cols do
					local col = col_msg[j].col;
					local szcell = se_getcell(i,col); --��Ԫ������
					if szcell ~= nil and szcell ~= "" then
						 tfile[section].property[col_msg[j].text] = szcell;
					end
				end
			end
		end

	end

    se_trace("�����ļ�" .. item.name );
	local hfile = se_openfile(se_transdir(DatFilePath .. "\\" ..item.subdir .. "\\" .. item.name));
	if hfile == nil then
	    se_trace("error".."�����ļ�" .. item.name .."ʧ��");
	    return 0;
	end
	for _ , r in pairsByKeys(tfile) do
		se_write( hfile,"\r\n[" .. r.section .. "]\r\n");
		for ss , p in pairsByKeys(r.property) do
			se_write(hfile, ss  .. "=" .. p .. "\r\n");
		end
	end
	se_colsefile(hfile);
	return 1;
end

--1�����ļ�ת��  ���������ת��
function trans_type1(item)
    local steps = item.step;
	--����Ϊ���򷵻�
	if table.getn(steps) <= 0 then
		se_trace( "steps Ϊ��" );
		return 0;
	end

	local tfile = {};
	--���ζ�ȡÿ��sheet
	for _ , src in ipairs(steps) do
		local szexcel = se_transdir(ExcelPath .. '\\' .. src.excel);
		local szsheet = src.sheet;
		--��ʧ����ֱ�ӷ���
		if se_openexcel(szexcel,szsheet) ~= 1 then
			se_trace("ת��" .. src.excel .. ":" .. src.sheet .. "ʱ����");
			return 0;
		end
		se_trace("����" .. src.excel .. ":" .. src.sheet);
		local max_row = se_getmax_row();	--�������
		local max_col = se_getmax_col();	--�������
		if max_row <= 2 then
			--��ʾ��������
			se_trace("error".."Excel����̫��" .. src.excel .. ":" .. src.sheet);
			return 0;
		end

		local szid = se_getcell(2,1);
		if szid ~= "ID" then
		    se_trace("A2 ��Ԫ�������ID");
			return 0;
		end

		local col_msg = {};
		local col_count = 1;
		--��������Ϣ
		for c = 2 , max_col do
			local szcell = se_getcell(2,c);
			if szcell ~= nil and szcell ~= "" then
			    if col_msg[col_count] == nil then
					col_msg[col_count] = {};
				end
				col_msg[col_count].col = c;
				col_msg[col_count].text = szcell;
				col_count = col_count + 1;
			end
		end

		local cols = table.getn(col_msg); --ָ�����ɵ�������
		if  cols < 1 then
			--��ʾcols��Ϊ��
			se_trace("error".."Excel������û��" .. src.excel .. ":" .. src.sheet);
			return 0;
		end

		for i = 3 , max_row do
   			local section = se_getcell(i,1);
			if section ~= nil and section ~= "" then
			    if tfile[section] == nil then
					tfile[section] = {};
					tfile[section].section = "";
					tfile[section].rows = {};
				end
    			tfile[section].section = section;
    			local rn = "";
				for j = 1 , cols do
					local col = col_msg[j].col;
					local szcell = se_getcell(i,col); --��Ԫ������
					if szcell ~= nil and szcell ~= "" then
                    	if rn ~= "" then
							rn = rn .. ",";
						end
						rn = rn .. szcell;
					end
				end
				table.insert(tfile[section].rows,rn);
			end
		end

	end

    se_trace("�����ļ�" .. item.name );
  	local hfile = se_openfile(se_transdir(DatFilePath .. "\\" ..item.subdir .. "\\" .. item.name));
	if hfile == nil then
 		se_trace("error".."�����ļ�" .. item.name .."ʧ��");
	    return 0;
	end
	for _ , r in pairsByKeys(tfile) do
		se_write( hfile,"\r\n[" .. r.section .. "]\r\n");
		for i , row in pairs(r.rows) do
			se_write(hfile, "r=" .. row .. "\r\n");
		end
	end
	se_colsefile(hfile);
end

--2�����ļ�ת��  ����������ת��
function trans_type2(item)
    local steps = item.step;
	--����Ϊ���򷵻�
	if table.getn(steps) <= 0 then
		se_trace( "steps Ϊ��" );
		return 0;
	end
end

--3�����ļ�ת��  ��r����ת��
function trans_type3(item)
    local steps = item.step;
	--����Ϊ���򷵻�
	if table.getn(steps) <= 0 then
		se_trace( "steps Ϊ��" );
		return 0;
	end

	local tfile = {};
	--���ζ�ȡÿ��sheet
	for _ , src in ipairs(steps) do
		local szexcel = se_transdir(ExcelPath .. '\\' .. src.excel);
		local szsheet = src.sheet;
		--��ʧ����ֱ�ӷ���
		if se_openexcel(szexcel,szsheet) ~= 1 then
			se_trace("ת��" .. src.excel .. ":" .. src.sheet .. "ʱ����");
			return 0;
		end
		se_trace("����" .. src.excel .. ":" .. src.sheet);
		local max_row = se_getmax_row();	--�������
		local max_col = se_getmax_col();	--�������
		if max_row <= 2 then
			--��ʾ��������
			se_trace("error".."Excel����̫��" .. src.excel .. ":" .. src.sheet);
			return 0;
		end

		local szid = se_getcell(2,1);
		if szid ~= "ID" then
		    se_trace("A2 ��Ԫ�������ID");
			return 0;
		end

		--�����û���ظ�ID
		local ct = {};
		for i = 3 , max_row do
			local sz = se_getcell(i,1);
			if sz ~= nil and sz ~= "" then
				if ct[sz] ~= nil then
				    se_trace("sheet" .. szsheet .. "�����ظ�ID" .. sz);
					return 0;
				else
				   ct[sz] = sz;
				end

			end
		end


		local col_msg = {};
		local col_count = 1;
		--��������Ϣ
		for c = 2 , max_col do
			local szcell = se_getcell(2,c);
			if szcell ~= nil and szcell ~= "" then
			    if col_msg[col_count] == nil then
					col_msg[col_count] = {};
				end
				col_msg[col_count].col = c;
				col_msg[col_count].text = szcell;
				col_count = col_count + 1;
			end
		end

		local cols = table.getn(col_msg); --ָ�����ɵ�������
		if  cols < 1 then
			--��ʾcols��Ϊ��
			se_trace("error".."Excel������û��" .. src.excel .. ":" .. src.sheet);
			return 0;
		end

		--sheet����Ϊsection�ֶ�
		if tfile[szsheet] ~= nil then
			se_trace("sheet" .. szsheet .. "�ظ�");
			return 0;
		end

		tfile[szsheet] = {};
		tfile[szsheet].section = szsheet;
		tfile[szsheet].rows = {};

		for i = 3 , max_row do
   			local section = se_getcell(i,1);
			if section ~= nil and section ~= "" then
    			local rn = "";
				for j = 1 , cols do
					local col = col_msg[j].col;
					local szcell = se_getcell(i,col); --��Ԫ������
					if szcell ~= nil and szcell ~= "" then
                    	if rn ~= "" then
							rn = rn .. ",";
						end
						rn = rn .. szcell;
					end
				end
				table.insert(tfile[szsheet].rows,section .. "=" ..rn);
			end
		end

	end

    se_trace("�����ļ�" .. item.name );
  	local hfile = se_openfile(se_transdir(DatFilePath .. "\\" ..item.subdir .. "\\" .. item.name));
	if hfile == nil then
		se_trace("error".."�����ļ�" .. item.name .."ʧ��");
	    return 0;
	end
	for _ , r in pairsByKeys(tfile) do
		se_write( hfile,"\r\n[" .. r.section .. "]\r\n");
		for i , row in pairs(r.rows) do
			se_write(hfile,row .. "\r\n");
		end
	end
	se_colsefile(hfile);
end

--4�����ļ�ת��  ���������� K=VALUE
function trans_type4(item)
    local steps = item.step;
	--����Ϊ���򷵻�
	if table.getn(steps) <= 0 then
		se_trace( "steps Ϊ��" );
		return 0;
	end

	local tfile = {};
	--���ζ�ȡÿ��sheet
	for _ , src in ipairs(steps) do
		local szexcel = se_transdir(ExcelPath .. '\\' .. src.excel);
		local szsheet = src.sheet;
		--��ʧ����ֱ�ӷ���
		if se_openexcel(szexcel,szsheet) ~= 1 then
			se_trace("ת��" .. src.excel .. ":" .. src.sheet .. "ʱ����");
			return 0;
		end
		se_trace("����" .. src.excel .. ":" .. src.sheet);
		local max_row = se_getmax_row();	--�������
		local max_col = se_getmax_col();	--�������
		if max_row <= 2 then
			--��ʾ��������
			se_trace("error".."Excel����̫��" .. src.excel .. ":" .. src.sheet);
			return 0;
		end

		if max_col ~= 4 then
			--��ʾ��������
			se_trace("error".."Excel��������" .. src.excel .. ":" .. src.sheet);
			return 0;
		end

		local szid = se_getcell(2,1);
		if szid ~= "ID" then
		    se_trace("A2 ��Ԫ�������ID");
			return 0;
		end


		for i = 3 , max_row do
   			local section = se_getcell(i,1);
			if section ~= nil and section ~= "" then
				if tfile[section] == nil then
					tfile[section] = {};
					tfile[section].section = section;
					tfile[section].rows = {};
				end

				local prokey = se_getcell(i,3);
				local provalue = se_getcell(i,4);

				table.insert(tfile[section].rows,prokey .. "=" ..provalue);
			end
		end

	end

    se_trace("�����ļ�" .. item.name );
  	local hfile = se_openfile(se_transdir(DatFilePath .. "\\" ..item.subdir .. "\\" .. item.name));
	if hfile == nil then
		se_trace("error".."�����ļ�" .. item.name .."ʧ��");
	    return 0;
	end
	for _ , r in pairsByKeys(tfile) do
		se_write( hfile,"\r\n[" .. r.section .. "]\r\n");
		for i , row in pairs(r.rows) do
			se_write(hfile,row .. "\r\n");
		end
	end
	se_colsefile(hfile);
end

--5�����ļ�ת��  sec˳�����С���
function trans_type5(item)

	local steps = item.step;
	--����Ϊ���򷵻�
	if table.getn(steps) <= 0 then
		se_trace( "steps Ϊ��" );
		return 0;
	end

	local tfile = {};
	local scount = 0;
	--���ζ�ȡÿ��sheet
	for _ , src in ipairs(steps) do
		local szexcel = se_transdir(ExcelPath .. '\\' .. src.excel);
		local szsheet = src.sheet;
		--��ʧ����ֱ�ӷ���

		if se_openexcel(szexcel,szsheet) ~= 1 then
			se_trace("ת��" .. src.excel .. ":" .. src.sheet .. "ʱ����");
			return 0;
		end

		se_trace("����" .. src.excel .. ":" .. src.sheet);
		local max_row = se_getmax_row();	--�������
		local max_col = se_getmax_col();	--�������
		if max_row <= 2 then
			--��ʾ��������
			se_trace("error".."Excel����̫��" .. src.excel .. ":" .. src.sheet);
			return 0;
		end

		local col_msg = {};
		local col_count = 1;
		--��������Ϣ
		for c = 1 , max_col do
			local szcell = se_getcell(2,c);
			if szcell ~= nil and szcell ~= "" then
			    if col_msg[col_count] == nil then
					col_msg[col_count] = {};
				end
				col_msg[col_count].col = c;
				col_msg[col_count].text = szcell;
				col_count = col_count + 1;
			end
		end

		local cols = table.getn(col_msg); --ָ�����ɵ�������
		if  cols < 1 then
			--��ʾcols��Ϊ��
			se_trace("error".."Excel������û��" .. src.excel .. ":" .. src.sheet);
			return 0;
		end

		for i = 4 , max_row do
   			local section = i - 4
			if section ~= nil and section ~= "" then
			  if tfile[section] == nil then
					tfile[section] = {};
					tfile[section].section = "";
					tfile[section].property = {};
				end
				tfile[section].section = i - 4;
				for j = 1 , cols do
					local col = col_msg[j].col;
					local szcell = se_getcell(i,col); --��Ԫ������
					if szcell ~= nil and szcell ~= "" then
						 tfile[section].property[col_msg[j].text] = szcell;
					end
				end
			end
		end

	end

  se_trace("�����ļ�" .. item.name );
	local hfile = se_openfile(se_transdir(DatFilePath .. "\\" ..item.subdir .. "\\" .. item.name));
	if hfile == nil then
	    se_trace("error".."�����ļ�" .. item.name .."ʧ��");
	    return 0;
	end

	for _ , r in pairsByKeys(tfile) do
		se_write( hfile,"\r\n[" .. r.section .. "]\r\n");
		for ss , p in pairsByKeys(r.property) do
			se_write(hfile, ss  .. "=" .. p .. "\r\n");
		end
	end
	se_colsefile(hfile);
	return 1;
end

--�������������ɺ����Ķ�Ӧ
type_fun = {
	[0] = trans_type0,
	[1] = trans_type1,
	[2] = trans_type2,
	[3] = trans_type3,
	[4] = trans_type4,
	[5] = trans_type5,
};
