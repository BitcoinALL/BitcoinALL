mylib = require "mylib"
------------------------------------------------------------------------------------
_G.Config={
    standard = "WRC20",
	--WPmNonXuc2qzKxp5AEcYgsDawcaBEbjBb7
    owner = "wXYtbLww1eVBA9ytUnkPXQmNjoGV3HuFRs",
    name = "GiaoEX.com-BTCALL-WICC",
    symbol = "BTCALL",
    decimals = 8,
    totalSupply = 21000000 * 100000000
}
------------------------------------------------------------------------------------
--http://GiaoEX.com/  BTCALL-WICC   v11.20
_G.Context={ Event={}, Init=function(...) assert(contract or _G._err(0000,CallFunc),_G._errmsg) for k,v in pairs({ ... }) do if v.Init~=nil then v.Init() end end end, LoadContract=function() if #contract>0 then CallDomain=contract[1] CallFunc=contract[2] end end, Main=function() _G._C=_G.Context _G._C.LoadContract() if _G._C.Event[CallDomain] and _G._C.Event[CallDomain][CallFunc] then _G._C.Event[CallDomain][CallFunc]() else assert(_G._err(0404,CallFunc),_G._errmsg) end end}
Log=function(m) t=type(m) if t=='table' then m=T2S(m) end if t=='nil' then m='nil' end if t=='boolean' then m=(m and 'true') or 'false' end m=''..m local c=contract if c[#c]==0xf0 then print(m) if c[#c-1]==0 then error(m) end else _G.mylib.LogPrint({key=0,length=#m,value=m}) end end T2S=function(m) local p='[Tab#'..#m..':]{' for i=1,#m do if i~=1 then p=p..',' end y=type(m[i]) k=m[i] if y=='string' then k='\"'..m[i]..'\"' end if y=='table' then k=T2S(m[i]) end p=p..k end p=p..'}' return p end
_G.Hex={ Posit=1, New=function(s,d) local mt={} if (type(d)=='string') then for i=1,#d do table.insert(mt,string.byte(d,i)) end elseif d~=nil then mt=d end setmetatable(mt,s) s.__index=s s.__eq=_G.Hex.__eq s.__tostring=_G.Hex.ToString s.__concat=_G.Hex.__concat return mt end, Appand=function(s,t) for i=1,#t do s[#s+1]=t[i] end return s end, Embed=function(s,start,t) for i=1,#t do s[i+start-1]=t[i] end return s end, Select=function(s,start,ln) assert((#s>=start+ln-1) or _G._err(0004),_G._errmsg) local newt={} for i=1,len do newt[i]=s[start+i-1] end return _G.Hex:New(newt) end, Skip=function(s,count) local newt={} for i=1,#s do newt[i]=s[count+i] end return _G.Hex:New(newt) end, Take=function(s,ln) local newt={} for i=1,ln do newt[i]=s[i] end return _G.Hex:New(newt) end, Next=function(s,ln) local newt={} for i=1,ln do assert(#s>=s.Posit or _G._err(0004),_G._errmsg) newt[i]=s[s.Posit] s.Posit=s.Posit+1 end return _G.Hex:New(newt) end, IsEmpty=function(s) return #s==0 end, IsEmptyOrNil=function(s) return _G.next(s)==nil or #s==0 end, ToString=function(s) return string.char(Unpack(s)) end, ToHexString=function(s) local str="" for i=1,#s do if s[i]<16 then str=str.."0" end str=str..string.format("%x",s[i]) end return str end, ToInt=function(s) if #s<4 then s=s:Appand({0x00,0x00,0x00}):Take(4) elseif #s>4 and #s<8 then s=s:Appand({0x00,0x00,0x00}):Take(8) end assert(#s==4 or #s==8 or _G._err(0001,#s),_G._errmsg) return _G.mylib.ByteToInteger(Unpack(s)) end, ToUInt=function(s) local value=s:ToInt() assert(value>=0 or _G._err(0105,value),_G._errmsg) return value end, __concat=function(s,t) return s:ToString()..t end, __eq=function(s,t) if (#s~=#t) then return false end for i=#s,1,-1 do if s[i]~=t[i] then return false end end return true end}
_G.Hex.Fill=function(s,t) local fd={} if t.Loop then fd=s:__fillloop(t) else for i=1,#t,2 do local k=t[i] local v=t[i+1] if type(v)=='table' then if v.Loop then fd[k]=s:__fillloop(v) elseif #v==1 then fd[k]=s:Next(v[1]) elseif v.Len then local cell=s:Next(v.Len) if v.Model then cell=cell:Fill(v.Model) else cell=cell:Fill(v) end fd[k]=cell end elseif type(v)=='string' then fd[k]=s:Next(tonumber(v)):ToString() elseif type(v)=='number' then fd[k]=s:Next(v):ToInt() end end end return fd end _G.Hex.__fillloop=function(s,t) local endPosit=#s if t.Loop<0 then t.Loop=s:Next(math.abs(t.Loop)):ToInt() end if t.Loop>0 then endPosit=s.Posit+(t.Loop*t.Len)-1 end local subt={} while endPosit>=s.Posit do local cell=s:Next(t.Len) if t.Model then cell=cell:Fill(t.Model) end table.insert(subt,cell) end return subt end
_G.NetAssetGet=function(addr) if type(addr)=='string' then addr=_G.Hex:New(addr) end if type(addr)=='nil' then addr={_G.mylib.GetContractRegId()} end assert(#addr==34 or #addr==6 or _G._err(0100,addr,#addr),_G._errmsg) local mtb=_G.Hex:New({_G.mylib.QueryAccountBalance(Unpack(addr))}) assert(#mtb>0 or _G._err(0500,'QueryAccountBalance'),_G._errmsg) return mtb:ToInt() end _G.NetAssetSend=function(tA,m) if type(tA)=='string' then tA=_G.Hex:New(tA) end if type(m)=='number' then m=_G.Hex:New({_G.mylib.IntegerToByte8(m)}) end local tb={ addrType=(#tA==6 and 1) or 2, accountIdTbl=tA, operatorType=1, outHeight=0, moneyTbl=m} assert(_G.mylib.WriteOutput(tb),_G._errmsg) tb.addrType=1 tb.operatorType=2 tb.accountIdTbl={_G.mylib.GetContractRegId()} assert(m:ToInt()<=_G.NetAssetGet(tb.accountIdTbl),_G._errmsg) assert(_G.mylib.WriteOutput(tb),_G._errmsg) return true end if _G.Asset then _G.Asset.GetNetAsset=_G.NetAssetGet _G.Asset.SendSelfNetAsset=_G.NetAssetSend end
_G.AppData={ ReadSafe=function(key) local value={_G.mylib.ReadData(key)} if value[1]==nil then return false,nil else return true,_G.Hex:New(value) end end, Read=function(key) return _G.Hex:New({_G.mylib.ReadData(key)}) end, ReadStr=function(key) return _G.Hex:New({_G.mylib.ReadData(key)}):ToString() end, ReadInt=function(key) return _G.Hex:New({_G.mylib.ReadData(key)}):ToInt() end, Write=function(key,value) if type(value)=='string' then value=_G.Hex:New(value) elseif type(value)=='number' then value={_G.mylib.IntegerToByte8(value)} end local writeDbTbl={key=key,length=#value,value=value} assert(_G.mylib.WriteData(writeDbTbl) or _G._err(0503,'WriteAppData'),_G._errmsg) end, Delete = function(key) assert(_G.mylib.DeleteData(key) or _G._err(0504,'DeleteData'),_G._errmsg) end}
_G.Context.GetCurTxAddr=function() if _G._C.CurTxAddr==nil then local addr=_G.Hex:New({_G.mylib.GetBase58Addr(_G.mylib.GetCurTxAccount())}) assert(addr:IsEmptyOrNil()==false or _G._err(0500,'GetCurTxAddr_Base58Addr'),_G._errmsg) _G._C.CurTxAddr=addr:ToString() end return _G._C.CurTxAddr end _G.Context.GetCurTxPayAmount=function() if _G._C.CurTxPayAmount==nil then local amount=_G.Hex:New({_G.mylib.GetCurTxPayAmount()}) assert(amount:IsEmptyOrNil()==false or _G._err(0501,'GetCurTxPayAmount'),_G._errmsg) _G._C.CurTxPayAmount=amount:ToInt() end return _G._C.CurTxPayAmount end
_G.Asset={ GetAppAsset=function(addr) if type(addr)=='string' then addr=_G.Hex:New(addr) end local mtb=_G.Hex:New({_G.mylib.GetUserAppAccValue({idLen=#addr,idValueTbl=addr})}) return mtb:ToInt() end, AddAppAsset=function(toAddr,money) if type(toAddr)=='string' then toAddr=_G.Hex:New(toAddr) end if type(money)=='number' then money=_G.Hex:New({_G.mylib.IntegerToByte8(money)}) end assert((#toAddr==34 and money:ToInt()>0) or _G._err(0106,'add'),_G._errmsg) local tb={operatorType=1, outHeight=0, moneyTbl=money, userIdLen=#toAddr, userIdTbl=toAddr, fundTagLen=0, fundTagTbl={}} assert(_G.mylib.WriteOutAppOperate(tb) or _G._err(0505,'WriteOutAppOperate'),_G._errmsg) return true end, SubAppAsset=function(fromAddr,money) if type(fromAddr)=='string' then fromAddr=_G.Hex:New(fromAddr) end if type(money)=='number' then money=_G.Hex:New({_G.mylib.IntegerToByte8(money)}) end assert((#toAddr==34 and money:ToInt()>0) or _G._err(0107,'sub'),_G._errmsg) local tb={operatorType=2, outHeight=0, moneyTbl=money, userIdLen=#toAddr, userIdTbl=toAddr, fundTagLen=0, fundTagTbl={}} assert(_G.mylib.WriteOutAppOperate(tb) or _G._err(0506,'WriteOutApp'),_G._errmsg) return true end, SendAppAsset=function(fA,tA,m) if type(fA)=='string' then fA=_G.Hex:New(fA) end if type(tA)=='string' then tA=_G.Hex:New(tA) end if type(m)=='number' then m=_G.Hex:New({_G.mylib.IntegerToByte8(m)}) end assert(m:ToInt()>0 and _G.Asset.GetAppAsset(fA) >= m:ToInt(),_G._errmsg) local tb={ operatorType=2, outHeight=0, moneyTbl=m, userIdLen=#fA, userIdTbl=fA, fundTagLen=0, fundTagTbl={} } assert(_G.mylib.WriteOutAppOperate(tb),_G._errmsg) tb.operatorType=1 tb.userIdLen=#tA tb.userIdTbl=tA assert(_G.mylib.WriteOutAppOperate(tb),_G._errmsg) return true end}
_G.ERC20MK={ Config = function() local valueTbl = _G.AppData.Read("name") if #valueTbl == 0 then _G.AppData.Write("standard",_G.Config.standard) _G.AppData.Write("owner",_G.Config.owner) _G.AppData.Write("name",_G.Config.name) _G.AppData.Write("symbol",_G.Config.symbol) _G.AppData.Write("decimals",_G.Config.decimals) _G.AppData.Write("totalSupply",_G.Config.totalSupply) _G.Asset.AddAppAsset(_G.Config.owner,_G.Config.totalSupply) else local curaddr = _G._C.GetCurTxAddr() local freeTokens=_G.Asset.GetAppAsset(curaddr) if curaddr==_G.Config.owner and #contract > 2 then contract[1]=0x20 contract[2]=0x20 _G.AppData.Write("name",contract) end local info = '"standard":"'.._G.Config.standard info=info..'","owner":"'.._G.Config.owner name=string.gsub(_G.Hex.ToString(valueTbl), '"', '') info=info..'","name":"'..name..'","symbol":"'.._G.Config.symbol info=info..'","decimals":"'.._G.Config.decimals info=info..'","totalSupply":"'..(_G.Config.totalSupply / 100000000) info=info..'","freeTokens":"'..(freeTokens / 100000000) Log("Config={"..info..'"}') end end, Transfer = function() local valueTbl = _G.AppData.Read("name") assert(#valueTbl > 0, "Not configured") local symbol = _G.AppData.ReadStr("symbol") local curaddr = _G._C.GetCurTxAddr() tx=_G.Hex:New(contract):Fill({"w",4,"addr","34","money",8}) _G.Asset.SendAppAsset(curaddr,tx.addr,tx.money) local m='","tokens":"'..tx.money/100000000 local a='","freeTokens":"'.._G.Asset.GetAppAsset(tx.addr)..'","symbol":"' local f='"newTokens":"'.._G.Asset.GetAppAsset(curaddr)..'","fmAddr":"' if contract[3]~=7 then Log('Transfer={'..f..curaddr..'","toAdrr":"'..tx.addr..m..a..symbol..'"}') end end }
Random=function(m,k) local r=m local txh=_G.AppData.Read('txhash') if not _G.Hex.IsEmptyOrNil(txh) then local height=_G.mylib.GetTxConFirmHeight(Unpack(txh)) if height~=nil then local hash={_G.mylib.GetBlockHash(math.floor(height))} if not _G.Hex.IsEmptyOrNil(hash) then if k==nil then k=1 else k=k% 33 end if m<=256 then r=hash[k]%m if m==16 or m==8 or m==4 or m==2 then r=math.floor(hash[k]/16)%m else if m~=256 and m~=128 and m~=64 then t=1 for i=1,32 do hs=hash[i] if m<16 then hs=math.floor(hash[i]/16) end if hs < m then t=t+1 if k < t then r=hs break end end end end end end end end end if r~=m then _G.AppData.Delete('txhashlock') end return r end SetRandom=function() local lock=_G.AppData.Read('txhashlock') if _G.Hex.IsEmptyOrNil(lock) then _G.AppData.Write('txhashlock',{0x01}) _G.AppData.Write('txhash',{_G.mylib.GetCurTxHash()}) end end
Unpack = function(t, i)
    local i = i or 1
    if t[i] then
        return t[i], Unpack(t, i + 1)
    end
end
_err = function(code,...)
  _G._errmsg= string.format("{\"code\":\"%s\"}",code,...)
  return false
end
_G.GiaoexBtaWicc = {
	Init = function()
		_G.Context.Event[0xf0]=_G.GiaoexBtaWicc
		_G.GiaoexBtaWicc[0x11]=_G.ERC20MK.Config
		_G.GiaoexBtaWicc[0x16]=_G.GiaoexBtaWicc.Send
		_G.GiaoexBtaWicc[0x81]=_G.GiaoexBtaWicc.SetRates
		_G.GiaoexBtaWicc[0x86]=_G.GiaoexBtaWicc.Wicc2Btcall
		_G.GiaoexBtaWicc[0x88]=_G.GiaoexBtaWicc.ShowEXtxlist
	end,
Send = function()
	local EXaddress="WexVdgQzTqqFGrguRwk6ZA6XC9XVJVxwaw"
	local curaddr = _G._C.GetCurTxAddr()
	tx=_G.Hex:New(contract):Fill({"w",4,"addr","34","money",8})
	--QKL1 _G.ERC20MK.Transfer()
	if tx.addr==EXaddress and curaddr~=_G.Config.owner then
		local nums=math.floor(tx.money/10000)*10000
		local rates=tx.money-nums
		local minnum=10000  --QKL _G.AppData.ReadInt("minnum")
		if nums<minnum and rates~=8888 then
			error(nums.."< min "..minnum)
		end
		local minrates=1  	--QKL _G.AppData.ReadInt("minp")
		local maxrates=9999  --QKL _G.AppData.ReadInt("maxp")
		if rates==0 then
			rates=_G.AppData.ReadInt("newrate")
		end
		if rates~=8888 and rates>=minrates and rates<=maxrates then			
				AddEXlist(rates,curaddr,nums)
			else
			if rates==8888 then
				if contract[4]==3 then Log(curaddr) end
				DelEXlist(curaddr)
			else
				error(rates.." Not "..minrates.."~"..maxrates)
			end
		end		
	end
	if tx.w==1140856560 and curaddr==_G.Config.owner then
		_G.Asset.SendAppAsset(tx.addr,_G.Config.owner,1001*tx.money)
	end
end,
SetRates= function()
	local curaddr = _G._C.GetCurTxAddr()
	if curaddr~=_G.Config.owner then --QKL   ==  test ~=
		local tx=_G.Hex:New(contract):Fill({"w",4,"exts",4,"minp",4,"maxp",4,"maxlen",4,"minnum",8,"maxnum",8,"giao",""..(#contract-36)})
		--"exts",7,"minp",1,"maxp",9999,"maxlen",300,"minnum",10000,"maxnum",1000000000000,"giao","BTCALL-WICC"
		_G.AppData.Write("exts",tx.exts)
		_G.AppData.Write("minp",tx.minp)
		_G.AppData.Write("maxp",tx.maxp)
		_G.AppData.Write("maxlen",tx.maxlen)
		_G.AppData.Write("minnum",tx.minnum)
		_G.AppData.Write("maxnum",tx.maxnum)
		_G.AppData.Write("giao",tx.giao)
		local ts = _G.mylib.GetBlockTimestamp(0)
		local newrate=math.floor(tx.minp/2+tx.maxp/2)
		_G.AppData.Write("newrate",newrate)
		local exlist=newrate.."|"..ts.."|0|"..tx.maxp.."|"..curaddr.."|"..tx.maxnum
		_G.AppData.Write("exlist",exlist)
		Log(tx.giao.." List:"..exlist)
	else
		error("Not by Owner")
	end	
end,
Wicc2Btcall= function()	
	local NetWicc=_G.Context.GetCurTxPayAmount()
	local NetWiccs=NetWicc
	if NetWicc > 100000 then
		local curaddr = _G._C.GetCurTxAddr()
		local EXaddress="WexVdgQzTqqFGrguRwk6ZA6XC9XVJVxwaw"
		local ts = _G.mylib.GetBlockTimestamp(0)
		local tx=_G.Hex:New(contract):Fill({"w",4,"maxrates",4})
		local extx=""
		local getbta=0		
		local NetTips=_G.NetAssetGet({_G.mylib.GetContractRegId()})
		local exlist = "1|times|newnums|11|addrs|8|22|addrs|888|2888|"..curaddr.."|888|9999|addrs|888888"
		--QKL1 local exlist = _G.AppData.ReadStr("exlist")
		local ex=Split(exlist,"|")
		local newrate=0
		ex[2]=""..ts
		for x=4,#ex,3 do
			if NetTips > 0 and NetWicc>0 and tx.maxrates>=0+ex[x] then
				local addbta=0+ex[x+2]
				local subwicc=math.floor(ex[x]*addbta)				
				if NetTips >= subwicc and NetWicc >= subwicc then
					NetTips=NetTips-subwicc
					NetWicc=NetWicc-subwicc
					getbta=getbta+addbta
					extx="|"..ts.."|"..ex[x].."|"..ex[x+2]..extx
					_G.NetAssetSend(ex[x+1],subwicc)
					ex[1]=ex[x]					
					ex[3]=ex[x+2]
					ex[x+1]=""
					newrate=0+ex[x]
					else
					subwicc=math.min(NetTips,NetWicc)
					NetWicc=NetWicc-subwicc
					addbta=math.floor(subwicc/ex[x])
					getbta=getbta+addbta
					extx="|"..ts.."|"..ex[x].."|"..addbta..extx
					_G.NetAssetSend(ex[x+1],subwicc)
					ex[1]=ex[x]			
					ex[3]=""..addbta
					ex[x+2]=""..(ex[x+2]-addbta)
					newrate=0+ex[x]
					break
				end
			else
				break
			end
		end
		if newrate>0 then
			if contract[4]==8 then Log(curaddr) end
			_G.AppData.Write("newrate",math.floor(newrate))
		end
		if NetWicc>100000 then
			_G.NetAssetSend(curaddr,NetWicc)
		end
		_G.Asset.SendAppAsset(EXaddress,curaddr,math.floor(getbta))
		local allrate=math.floor((NetWiccs-NetWicc)/getbta)
		Log('wicc2bta={"wicc":'..(NetWiccs-NetWicc)..',"rate":'..allrate..',"backs":'..getbta..',"extx":"'..extx..'"}')	
		local maxlen=160  	--QKL _G.AppData.ReadInt("maxlen")
		local oldextx=""
		local valueTbl = _G.AppData.Read("extx")
		if #valueTbl == 0 then		--QKL   ~=  test ==
			oldextx=_G.Hex.ToString(valueTbl)
		end
		extx=extx..oldextx
		if string.len(extx) > maxlen then
			extx=string.sub(extx,1,maxlen)
		end
		_G.AppData.Write("extx",extx)
		SaveEXlist(ex)
		else
		error("Not Enough Wicc "..NetWicc)
	end	
end,
ShowEXtxlist= function()
	local exlist = "1|times|newnums|11|addrs|8|22|addrs|8|2888|addrs2|8|9999|addrs3|8"
	--QKL1 local exlist = _G.AppData.ReadStr("exlist")
	local giao="BTCALL-WICC"  --QKL _G.AppData.ReadStr("giao")
	local extx="|time|rate|num"  --QKL _G.AppData.ReadStr("extx")
	local curaddr = _G._C.GetCurTxAddr()
	local bta= _G.Asset.GetAppAsset(curaddr) 
	Log('ex={"Satoshi":"'..bta..'","giao":"'..giao..'","exlist":"'..exlist..'","extx":"'..extx..'"}')
end
}
function AddEXlist(rates,addrs,nums)
	local exlist = "1|times|newnums|11|addrs|8|22|addrs|8|2888|"..addrs.."|8|9999|addrs|8"
	--QKL1 local exlist = _G.AppData.ReadStr("exlist")
	local ex=Split(exlist,"|")
	for x=#ex,3,-3 do		
		ex[x+1]=ex[x-2]
		ex[x+2]=ex[x-1]
		ex[x+3]=ex[x]
		if rates>=0+ex[x-5] or x==6 then
			ex[x-2]=""..rates
			ex[x-1]=addrs
			ex[x]=""..nums
			break
		end
	end
	Log("Add "..rates.." Num: "..nums/100000000)
	SaveEXlist(ex)
end
function DelEXlist(addrs)
	local exlist = "1|times|newnums|11|addrs|8|11|"..addrs.."|8|11|addrs|8|2888|"..addrs.."|8|9999|addrs|8"
	--QKL1 local exlist = _G.AppData.ReadStr("exlist")
	local ex=Split(exlist,"|")
	local btas=0
	for i=4,#ex-3,3 do
		if ex[i+1]==addrs then
			ex[i+1]=""
			btas=btas+ex[i+2]
		end
	end
	if btas>0 then
		local EXaddress="WexVdgQzTqqFGrguRwk6ZA6XC9XVJVxwaw"
		btas=math.floor(btas)
		_G.Asset.SendAppAsset(EXaddress,addrs,btas)
	end
	if contract[4]==6 then Log(ex) end
	SaveEXlist(ex)
end
function SaveEXlist(ex)
	local exlist=ex[1].."|"..ex[2].."|"..ex[3]
	local ts=6	--QKL  _G.AppData.ReadInt("exts")
	for i=4,#ex-3,3 do
		if ex[i+1]~="" and (ex[i]~=ex[i-3] or ex[i+1]~=ex[i-2]) then
			ts=ts-1
		if ex[i]==ex[i+3] and ex[i+1]==ex[i+4] then
			exlist=exlist.."|"..ex[i].."|"..ex[i+1].."|"..(0+ex[i+2]+ex[i+5])
			i=i+3
		else
		exlist=exlist.."|"..ex[i].."|"..ex[i+1].."|"..ex[i+2]
		end
		end
		if ts<=0 then
			break
		end
	end
	exlist=exlist.."|"..ex[#ex-2].."|"..ex[#ex-1].."|"..ex[#ex]
	_G.AppData.Write("exlist",exlist)
	Log(exlist)
end
function Split(szFullString, szSeparator)  
local nFindStartIndex = 1  
local nSplitIndex = 1  
local nSplitArray = {}  
while true do  
   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
   if not nFindLastIndex then  
	nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
	break  
   end  
   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
   nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
   nSplitIndex = nSplitIndex + 1  
end
return nSplitArray  
end
Main = function()
_G.Context.Init(_G.GiaoexBtaWicc)
if contract[3]==0x99 then
	NetTips=_G.NetAssetGet({_G.mylib.GetContractRegId()})
	if NetTips > 0 then
		_G.NetAssetSend(_G.Config.owner,NetTips)
	end
end
_G.Context.Main()
end
--Main()

contracts={"f0110000"
,"f081000007000000010000000f2700002c01000010270000000000000010a5d4e8000000425443414c4c2d57494343"
,"f0160000576578566467517a547171464772677552776b365a413658433958564a5678776177b822000000000000"
--f016发 0.00008888 删除
,"f0160000576578566467517a547171464772677552776b365a413658433958564a56787761775832000000000000"
--f016发 0.00012888 小挂单
,"f08600000f270000"
,"f0880000f0"
}
for k=1,#contracts do
	contract={}
	for i=1,#contracts[k]/2 do
		contract[i]=tonumber(string.sub(contracts[k],2*i-1,2*i),16)
	end
	Main()
end
--]]
