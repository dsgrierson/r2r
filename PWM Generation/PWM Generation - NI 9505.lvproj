<?xml version='1.0'?>
<Project Type="Project" LVVersion="8008005">
   <Property Name="NI.LV.ExampleFinder" Type="Str">&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;nidna:ExampleProgram 
    xmlns:nidna="http://www.ni.com/Schemas/DNA/1.0" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xsi:schemaLocation="http://www.ni.com/Schemas/DNA/1.0 ..\DNA\1.0\NiExampleProgram.xsd" 
    SchemaVersion="1.0" 
    ContentType="EXAMPLE" 
&lt;Title&gt;
	&lt;Text Locale="US"&gt;PWM Generation - NI 9505.lvproj&lt;/Text&gt;
&lt;/Title&gt;
&lt;Description&gt;
	&lt;Text Locale="US"&gt;This project shows an example of how to implement a PWM generator for use with the NI 9505. The example uses a single-cycle Timed Loop to create a PWM frequency of 20kHz. The duty cycle input control is used to create the appropriate pulse width. The next duty cycle value is loaded at the beginning of each new period.&lt;/Text&gt;
&lt;/Description&gt;
&lt;Keywords&gt;
	&lt;Item&gt;9505&lt;/Item&gt;
	&lt;Item&gt;DC&lt;/Item&gt;
	&lt;Item&gt;NI&lt;/Item&gt;
	&lt;Item&gt;RIO&lt;/Item&gt;
	&lt;Item&gt;compact&lt;/Item&gt;
	&lt;Item&gt;CompactRIO&lt;/Item&gt;
	&lt;Item&gt;brushed&lt;/Item&gt;
	&lt;Item&gt;motors&lt;/Item&gt;
	&lt;Item&gt;motion&lt;/Item&gt;
	&lt;Item&gt;servo&lt;/Item&gt;
	&lt;Item&gt;drive&lt;/Item&gt;
	&lt;Item&gt;PWM&lt;/Item&gt;
	&lt;Item&gt;pulse&lt;/Item&gt;
	&lt;Item&gt;width&lt;/Item&gt;
	&lt;Item&gt;modulation&lt;/Item&gt;
	&lt;Item&gt;generating&lt;/Item&gt;
	&lt;Item&gt;generation&lt;/Item&gt;
	&lt;Item&gt;duty&lt;/Item&gt;
	&lt;Item&gt;cycle&lt;/Item&gt;
	&lt;Item&gt;bridge&lt;/Item&gt;
&lt;/Keywords&gt;
&lt;Navigation&gt;
	&lt;Item&gt;8097&lt;/Item&gt;
	&lt;Item&gt;8101&lt;/Item&gt;
	&lt;Item&gt;8106&lt;/Item&gt;
&lt;/Navigation&gt;
&lt;FileType&gt;LV Project&lt;/FileType&gt;
&lt;Metadata&gt;
&lt;Item Name="RTSupport"&gt;RT LV Project&lt;/Item&gt;
&lt;/Metadata&gt;
&lt;ProgrammingLanguages&gt;
&lt;Item&gt;LabVIEW&lt;/Item&gt;
&lt;/ProgrammingLanguages&gt;
&lt;RequiredSoftware&gt;
&lt;NiSoftware MinVersion="8.0"&gt;LabVIEW&lt;/NiSoftware&gt; 
&lt;/RequiredSoftware&gt;
&lt;RequiredMotionHardware&gt;
&lt;Device&gt;
&lt;Family&gt;9505&lt;/Family&gt;
&lt;Model&gt;71ED&lt;/Model&gt;
&lt;/Device&gt;
&lt;/RequiredMotionHardware&gt;
</Property>
   <Property Name="NI.Project.Description" Type="Str">This project shows an example of how to implement a PWM generator for use with the NI 9505. The example uses a single-cycle Timed Loop to create a PWM frequency of 20kHz. The duty cycle input control is used to create the appropriate pulse width. The next duty cycle value is loaded at the beginning of each new period.</Property>
   <Item Name="My Computer" Type="My Computer">
      <Property Name="CCSymbols" Type="Str">OS,Win;CPU,x86;</Property>
      <Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
      <Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
      <Property Name="server.tcp.enabled" Type="Bool">false</Property>
      <Property Name="server.tcp.port" Type="Int">0</Property>
      <Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
      <Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
      <Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
      <Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
      <Property Name="specify.custom.address" Type="Bool">false</Property>
      <Item Name="Dependencies" Type="Dependencies"/>
      <Item Name="Build Specifications" Type="Build"/>
   </Item>
   <Item Name="RT CompactRIO Target" Type="RT CompactRIO">
      <Property Name="alias.name" Type="Str">RT CompactRIO Target</Property>
      <Property Name="alias.value" Type="Str">0.0.0.0</Property>
      <Property Name="CCSymbols" Type="Str">TARGET_TYPE,RT;OS,PharLap;CPU,x86;</Property>
      <Property Name="crio.family" Type="Str">900x</Property>
      <Property Name="host.TargetCPUID" Type="UInt">3</Property>
      <Property Name="host.TargetOSID" Type="UInt">15</Property>
      <Property Name="target.cleanupVisa" Type="Bool">false</Property>
      <Property Name="target.FPProtocolGlobals_ControlTimeLimit" Type="Int">300</Property>
      <Property Name="target.getDefault-&gt;WebServer.Port" Type="Int">80</Property>
      <Property Name="target.getDefault-&gt;WebServer.Timeout" Type="Int">60</Property>
      <Property Name="target.IsRemotePanelSupported" Type="Bool">true</Property>
      <Property Name="target.RTTarget.ApplicationPath" Type="Path">/c/ni-rt/startup/startup.rtexe</Property>
      <Property Name="target.RTTarget.EnableFileSharing" Type="Bool">true</Property>
      <Property Name="target.RTTarget.IPAccess" Type="Str">+*</Property>
      <Property Name="target.RTTarget.LaunchAppAtBoot" Type="Bool">false</Property>
      <Property Name="target.RTTarget.VIPath" Type="Path">/c/ni-rt/startup</Property>
      <Property Name="target.server.app.propertiesEnabled" Type="Bool">false</Property>
      <Property Name="target.server.control.propertiesEnabled" Type="Bool">false</Property>
      <Property Name="target.server.tcp.access" Type="Str">+*</Property>
      <Property Name="target.server.tcp.enabled" Type="Bool">false</Property>
      <Property Name="target.server.tcp.paranoid" Type="Bool">true</Property>
      <Property Name="target.server.tcp.port" Type="Int">3363</Property>
      <Property Name="target.server.tcp.serviceName" Type="Str">Main Application Instance/VI Server</Property>
      <Property Name="target.server.tcp.serviceName.default" Type="Str">Main Application Instance/VI Server</Property>
      <Property Name="target.server.vi.access" Type="Str">+*</Property>
      <Property Name="target.server.vi.callsEnabled" Type="Bool">false</Property>
      <Property Name="target.server.vi.propertiesEnabled" Type="Bool">false</Property>
      <Property Name="target.WebServer.Enabled" Type="Bool">false</Property>
      <Property Name="target.WebServer.LogEnabled" Type="Bool">false</Property>
      <Property Name="target.WebServer.LogPath" Type="Path">/c/ni-rt/system/www/www.log</Property>
      <Property Name="target.WebServer.Port" Type="Int">80</Property>
      <Property Name="target.WebServer.RootPath" Type="Path">/c/ni-rt/system/www</Property>
      <Property Name="target.WebServer.TcpAccess" Type="Str">C+*</Property>
      <Property Name="target.WebServer.Timeout" Type="Int">60</Property>
      <Property Name="target.WebServer.ViAccess" Type="Str">+*</Property>
      <Item Name="PWM Generation - NI 9505 (RT).vi" Type="VI" URL="PWM Generation - NI 9505 (RT).vi"/>
      <Item Name="FPGA Target" Type="FPGA Target">
         <Property Name="AutoRun" Type="Bool">false</Property>
         <Property Name="CCSymbols" Type="Str">TARGET_TYPE,FPGA;</Property>
         <Property Name="configString.guid" Type="Str">{38BEE52B-EF17-4553-9402-5835A6651735}NI 9505,Slot 4{6D0CB806-8B48-48F1-874A-A9F96937DD55}resource=/crio_NI 9505/Motor;0{825ECBDC-D99F-43F9-B8DD-44D4A751A42E}#!#!"1!!!")!&amp;E!Q`````QV3:8.P&gt;8*D:3"/97VF!"R!-0````]36'^Q)&amp;.J:WZB&lt;#"$&lt;WZO:7.U!!!;1$$`````%5.M&lt;W.L)&amp;.J:WZB&lt;#"/97VF!"B!#B*.;7YA2H*F=86F&lt;G.Z)#B)?CE!!"B!#B*.98AA2H*F=86F&lt;G.Z)#B)?CE!!"B!)2*798*J97*M:3"'=G6R&gt;76O9XE!!"R!#B:/&lt;WVJ&lt;G&amp;M)%:S:8&amp;V:7ZD?3!I3(IJ!!!=1!I85'6B;S"1:8*J&lt;W1A3GFU&gt;'6S)#BQ=SE!(%!+&amp;UVJ&lt;C"%&gt;82Z)%.Z9WRF)#AF)%BJ:WAJ!"R!#B&gt;.98AA2(6U?3"$?7.M:3!I*3");7&gt;I+1!51!I/17.D&gt;8*B9XEA+("Q&lt;3E!!"*!)1R'=G6F)&amp;*V&lt;GZJ&lt;G=!!"2!)1^4=(*F971A5X"F9X2S&gt;7U!%E!Q`````QB$&lt;'^D;S"*2!!!/%"!!!(`````!!UK5G6M982F:#"$&lt;'^D;X-A&gt;WFU;#"O&lt;S"$2%-A9W^N=(-A&lt;G6D:8.T98*Z!!!31&amp;--2W6O:8*J9S"%982B!!!/1$$`````"5&amp;M;7&amp;T!']!]1!!!!!!!!!")'ZJ=H:J1G&amp;T:624382F&lt;5.P&lt;G:J:X6S982J&lt;WYO9X2M!%6!5!!1!!!!!1!#!!-!"!!&amp;!!9!"Q!)!!E!#A!,!!Q!$A!0!"!&lt;1X6S=G6O&gt;#"$&lt;'^D;S"$&lt;WZG;7&gt;V=G&amp;U;7^O!!%!%1!!!"1U-#".3(IA4WZC&lt;W&amp;S:#"$&lt;'^D;Q!!!!6$&lt;'MU-!!!!!6$&lt;'MU-%'$%N!!!!!!19-3U!!!!!!!19-3U!!!!!"!&lt;U!!!!!!!%"*!!!!!!!!1%E!!!!!!!"!71!!!!!!!!%!!!!!!!A!A!5!!!!"!!1!!!!"!!!!!!!!!!!!&amp;$1Q)%V)?C"0&lt;G*P98*E)%.M&lt;W.L!!!!!!{A46CABE1-B9D2-42E0-A9DE-2921DD73672A}resource=/crio_NI 9505/Drive Direction;0cRIO-9103/falseTARGET_TYPEFPGA</Property>
         <Property Name="configString.name" Type="Str">40 MHz Onboard Clock#!#!"1!!!")!&amp;E!Q`````QV3:8.P&gt;8*D:3"/97VF!"R!-0````]36'^Q)&amp;.J:WZB&lt;#"$&lt;WZO:7.U!!!;1$$`````%5.M&lt;W.L)&amp;.J:WZB&lt;#"/97VF!"B!#B*.;7YA2H*F=86F&lt;G.Z)#B)?CE!!"B!#B*.98AA2H*F=86F&lt;G.Z)#B)?CE!!"B!)2*798*J97*M:3"'=G6R&gt;76O9XE!!"R!#B:/&lt;WVJ&lt;G&amp;M)%:S:8&amp;V:7ZD?3!I3(IJ!!!=1!I85'6B;S"1:8*J&lt;W1A3GFU&gt;'6S)#BQ=SE!(%!+&amp;UVJ&lt;C"%&gt;82Z)%.Z9WRF)#AF)%BJ:WAJ!"R!#B&gt;.98AA2(6U?3"$?7.M:3!I*3");7&gt;I+1!51!I/17.D&gt;8*B9XEA+("Q&lt;3E!!"*!)1R'=G6F)&amp;*V&lt;GZJ&lt;G=!!"2!)1^4=(*F971A5X"F9X2S&gt;7U!%E!Q`````QB$&lt;'^D;S"*2!!!/%"!!!(`````!!UK5G6M982F:#"$&lt;'^D;X-A&gt;WFU;#"O&lt;S"$2%-A9W^N=(-A&lt;G6D:8.T98*Z!!!31&amp;--2W6O:8*J9S"%982B!!!/1$$`````"5&amp;M;7&amp;T!']!]1!!!!!!!!!")'ZJ=H:J1G&amp;T:624382F&lt;5.P&lt;G:J:X6S982J&lt;WYO9X2M!%6!5!!1!!!!!1!#!!-!"!!&amp;!!9!"Q!)!!E!#A!,!!Q!$A!0!"!&lt;1X6S=G6O&gt;#"$&lt;'^D;S"$&lt;WZG;7&gt;V=G&amp;U;7^O!!%!%1!!!"1U-#".3(IA4WZC&lt;W&amp;S:#"$&lt;'^D;Q!!!!6$&lt;'MU-!!!!!6$&lt;'MU-%'$%N!!!!!!19-3U!!!!!!!19-3U!!!!!"!&lt;U!!!!!!!%"*!!!!!!!!1%E!!!!!!!"!71!!!!!!!!%!!!!!!!A!A!5!!!!"!!1!!!!"!!!!!!!!!!!!&amp;$1Q)%V)?C"0&lt;G*P98*E)%.M&lt;W.L!!!!!!cRIO-9103/falseTARGET_TYPEFPGADrive Directionresource=/crio_NI 9505/Drive Direction;0Motorresource=/crio_NI 9505/Motor;0NI 9505NI 9505,Slot 4</Property>
         <Property Name="Item Name" Type="Str">FPGA Target</Property>
         <Property Name="Mode" Type="Int">0</Property>
         <Property Name="Resource Name" Type="Str">RIO0::INSTR</Property>
         <Property Name="Target Class" Type="Str">cRIO-9103</Property>
         <Property Name="targetConfigString" Type="Str">cRIO-9103/falseTARGET_TYPEFPGA</Property>
         <Item Name="Digital Line Output" Type="Folder">
            <Item Name="NI 9505" Type="Folder">
               <Item Name="Motor" Type="Elemental IO">
                  <Property Name="eioAttrBag" Type="Xml"><AttributeSet name="FPGA Target 2">
   <Attribute name="resource">
   <Value>/crio_NI 9505/Motor</Value>
   </Attribute>
</AttributeSet>
</Property>
                  <Property Name="FPGA.PersistentID" Type="Str">{6D0CB806-8B48-48F1-874A-A9F96937DD55}</Property>
               </Item>
               <Item Name="Drive Direction" Type="Elemental IO">
                  <Property Name="eioAttrBag" Type="Xml"><AttributeSet name="FPGA Target 2">
   <Attribute name="resource">
   <Value>/crio_NI 9505/Drive Direction</Value>
   </Attribute>
</AttributeSet>
</Property>
                  <Property Name="FPGA.PersistentID" Type="Str">{A46CABE1-B9D2-42E0-A9DE-2921DD73672A}</Property>
               </Item>
            </Item>
         </Item>
         <Item Name="PWM Generation - NI 9505 (FPGA).vi" Type="VI" URL="PWM Generation - NI 9505 (FPGA).vi">
            <Property Name="configString.guid" Type="Str">{38BEE52B-EF17-4553-9402-5835A6651735}NI 9505,Slot 4{6D0CB806-8B48-48F1-874A-A9F96937DD55}resource=/crio_NI 9505/Motor;0{825ECBDC-D99F-43F9-B8DD-44D4A751A42E}#!#!"1!!!")!&amp;E!Q`````QV3:8.P&gt;8*D:3"/97VF!"R!-0````]36'^Q)&amp;.J:WZB&lt;#"$&lt;WZO:7.U!!!;1$$`````%5.M&lt;W.L)&amp;.J:WZB&lt;#"/97VF!"B!#B*.;7YA2H*F=86F&lt;G.Z)#B)?CE!!"B!#B*.98AA2H*F=86F&lt;G.Z)#B)?CE!!"B!)2*798*J97*M:3"'=G6R&gt;76O9XE!!"R!#B:/&lt;WVJ&lt;G&amp;M)%:S:8&amp;V:7ZD?3!I3(IJ!!!=1!I85'6B;S"1:8*J&lt;W1A3GFU&gt;'6S)#BQ=SE!(%!+&amp;UVJ&lt;C"%&gt;82Z)%.Z9WRF)#AF)%BJ:WAJ!"R!#B&gt;.98AA2(6U?3"$?7.M:3!I*3");7&gt;I+1!51!I/17.D&gt;8*B9XEA+("Q&lt;3E!!"*!)1R'=G6F)&amp;*V&lt;GZJ&lt;G=!!"2!)1^4=(*F971A5X"F9X2S&gt;7U!%E!Q`````QB$&lt;'^D;S"*2!!!/%"!!!(`````!!UK5G6M982F:#"$&lt;'^D;X-A&gt;WFU;#"O&lt;S"$2%-A9W^N=(-A&lt;G6D:8.T98*Z!!!31&amp;--2W6O:8*J9S"%982B!!!/1$$`````"5&amp;M;7&amp;T!']!]1!!!!!!!!!")'ZJ=H:J1G&amp;T:624382F&lt;5.P&lt;G:J:X6S982J&lt;WYO9X2M!%6!5!!1!!!!!1!#!!-!"!!&amp;!!9!"Q!)!!E!#A!,!!Q!$A!0!"!&lt;1X6S=G6O&gt;#"$&lt;'^D;S"$&lt;WZG;7&gt;V=G&amp;U;7^O!!%!%1!!!"1U-#".3(IA4WZC&lt;W&amp;S:#"$&lt;'^D;Q!!!!6$&lt;'MU-!!!!!6$&lt;'MU-%'$%N!!!!!!19-3U!!!!!!!19-3U!!!!!"!&lt;U!!!!!!!%"*!!!!!!!!1%E!!!!!!!"!71!!!!!!!!%!!!!!!!A!A!5!!!!"!!1!!!!"!!!!!!!!!!!!&amp;$1Q)%V)?C"0&lt;G*P98*E)%.M&lt;W.L!!!!!!{A46CABE1-B9D2-42E0-A9DE-2921DD73672A}resource=/crio_NI 9505/Drive Direction;0cRIO-9103/falseTARGET_TYPEFPGA</Property>
            <Property Name="configString.name" Type="Str">40 MHz Onboard Clock#!#!"1!!!")!&amp;E!Q`````QV3:8.P&gt;8*D:3"/97VF!"R!-0````]36'^Q)&amp;.J:WZB&lt;#"$&lt;WZO:7.U!!!;1$$`````%5.M&lt;W.L)&amp;.J:WZB&lt;#"/97VF!"B!#B*.;7YA2H*F=86F&lt;G.Z)#B)?CE!!"B!#B*.98AA2H*F=86F&lt;G.Z)#B)?CE!!"B!)2*798*J97*M:3"'=G6R&gt;76O9XE!!"R!#B:/&lt;WVJ&lt;G&amp;M)%:S:8&amp;V:7ZD?3!I3(IJ!!!=1!I85'6B;S"1:8*J&lt;W1A3GFU&gt;'6S)#BQ=SE!(%!+&amp;UVJ&lt;C"%&gt;82Z)%.Z9WRF)#AF)%BJ:WAJ!"R!#B&gt;.98AA2(6U?3"$?7.M:3!I*3");7&gt;I+1!51!I/17.D&gt;8*B9XEA+("Q&lt;3E!!"*!)1R'=G6F)&amp;*V&lt;GZJ&lt;G=!!"2!)1^4=(*F971A5X"F9X2S&gt;7U!%E!Q`````QB$&lt;'^D;S"*2!!!/%"!!!(`````!!UK5G6M982F:#"$&lt;'^D;X-A&gt;WFU;#"O&lt;S"$2%-A9W^N=(-A&lt;G6D:8.T98*Z!!!31&amp;--2W6O:8*J9S"%982B!!!/1$$`````"5&amp;M;7&amp;T!']!]1!!!!!!!!!")'ZJ=H:J1G&amp;T:624382F&lt;5.P&lt;G:J:X6S982J&lt;WYO9X2M!%6!5!!1!!!!!1!#!!-!"!!&amp;!!9!"Q!)!!E!#A!,!!Q!$A!0!"!&lt;1X6S=G6O&gt;#"$&lt;'^D;S"$&lt;WZG;7&gt;V=G&amp;U;7^O!!%!%1!!!"1U-#".3(IA4WZC&lt;W&amp;S:#"$&lt;'^D;Q!!!!6$&lt;'MU-!!!!!6$&lt;'MU-%'$%N!!!!!!19-3U!!!!!!!19-3U!!!!!"!&lt;U!!!!!!!%"*!!!!!!!!1%E!!!!!!!"!71!!!!!!!!%!!!!!!!A!A!5!!!!"!!1!!!!"!!!!!!!!!!!!&amp;$1Q)%V)?C"0&lt;G*P98*E)%.M&lt;W.L!!!!!!cRIO-9103/falseTARGET_TYPEFPGADrive Directionresource=/crio_NI 9505/Drive Direction;0Motorresource=/crio_NI 9505/Motor;0NI 9505NI 9505,Slot 4</Property>
            <Property Name="NI.LV.FPGA.InterfaceBitfile" Type="Str">C:\Program Files\National Instruments\LabVIEW 8.0\examples\CompactRIO\Module Specific\NI 9505\PWM Generation\FPGA Bitfiles\PWM Generation - N~87_FPGA Target_PWM Generation - N~B4.lvbit</Property>
         </Item>
         <Item Name="40 MHz Onboard Clock" Type="FPGA Base Clock">
            <Property Name="FPGA.PersistentID" Type="Str">{825ECBDC-D99F-43F9-B8DD-44D4A751A42E}</Property>
            <Property Name="NI.LV.FPGA.BaseTSConfig" Type="Bin">#!#!"1!!!")!&amp;E!Q`````QV3:8.P&gt;8*D:3"/97VF!"R!-0````]36'^Q)&amp;.J:WZB&lt;#"$&lt;WZO:7.U!!!;1$$`````%5.M&lt;W.L)&amp;.J:WZB&lt;#"/97VF!"B!#B*.;7YA2H*F=86F&lt;G.Z)#B)?CE!!"B!#B*.98AA2H*F=86F&lt;G.Z)#B)?CE!!"B!)2*798*J97*M:3"'=G6R&gt;76O9XE!!"R!#B:/&lt;WVJ&lt;G&amp;M)%:S:8&amp;V:7ZD?3!I3(IJ!!!=1!I85'6B;S"1:8*J&lt;W1A3GFU&gt;'6S)#BQ=SE!(%!+&amp;UVJ&lt;C"%&gt;82Z)%.Z9WRF)#AF)%BJ:WAJ!"R!#B&gt;.98AA2(6U?3"$?7.M:3!I*3");7&gt;I+1!51!I/17.D&gt;8*B9XEA+("Q&lt;3E!!"*!)1R'=G6F)&amp;*V&lt;GZJ&lt;G=!!"2!)1^4=(*F971A5X"F9X2S&gt;7U!%E!Q`````QB$&lt;'^D;S"*2!!!/%"!!!(`````!!UK5G6M982F:#"$&lt;'^D;X-A&gt;WFU;#"O&lt;S"$2%-A9W^N=(-A&lt;G6D:8.T98*Z!!!31&amp;--2W6O:8*J9S"%982B!!!/1$$`````"5&amp;M;7&amp;T!']!]1!!!!!!!!!")'ZJ=H:J1G&amp;T:624382F&lt;5.P&lt;G:J:X6S982J&lt;WYO9X2M!%6!5!!1!!!!!1!#!!-!"!!&amp;!!9!"Q!)!!E!#A!,!!Q!$A!0!"!&lt;1X6S=G6O&gt;#"$&lt;'^D;S"$&lt;WZG;7&gt;V=G&amp;U;7^O!!%!%1!!!"1U-#".3(IA4WZC&lt;W&amp;S:#"$&lt;'^D;Q!!!!6$&lt;'MU-!!!!!6$&lt;'MU-%'$%N!!!!!!19-3U!!!!!!!19-3U!!!!!"!&lt;U!!!!!!!%"*!!!!!!!!1%E!!!!!!!"!71!!!!!!!!%!!!!!!!A!A!5!!!!"!!1!!!!"!!!!!!!!!!!!&amp;$1Q)%V)?C"0&lt;G*P98*E)%.M&lt;W.L!!!!!!</Property>
            <Property Name="NI.LV.FPGA.Valid" Type="Bool">true</Property>
            <Property Name="NI.LV.FPGA.Version" Type="Int">1</Property>
         </Item>
         <Item Name="NI 9505" Type="RIO C Series Module">
            <Property Name="crio.Location" Type="Str">Slot 4</Property>
            <Property Name="crio.RequiresValidation" Type="Bool">false</Property>
            <Property Name="crio.SupportsDynamicRes" Type="Bool">false</Property>
            <Property Name="crio.Type" Type="Str">NI 9505</Property>
            <Property Name="FPGA.PersistentID" Type="Str">{38BEE52B-EF17-4553-9402-5835A6651735}</Property>
         </Item>
         <Item Name="Dependencies" Type="Dependencies"/>
         <Item Name="Build Specifications" Type="Build"/>
      </Item>
      <Item Name="Dependencies" Type="Dependencies"/>
      <Item Name="Build Specifications" Type="Build"/>
   </Item>
</Project>
