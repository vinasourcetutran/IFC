<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uComponentsInstaller.ascx.cs" Inherits="uComponents.Core.Install.uComponentsInstaller" EnableViewState="false" %>
<%@ Register Assembly="controls" Namespace="umbraco.uicontrols" TagPrefix="umb" %>

<div style="padding: 10px 10px 0;">

	<p><img src="<%= Logo %>" /></p>

	<asp:PlaceHolder runat="server" ID="Temp" Visible="true">
		
		<umb:Feedback runat="server" ID="Success" type="success" Text="uComponents successfully installed!" />
		<umb:Feedback runat="server" ID="Failure" type="error" Visible="false" />
		
		<p>Now that <strong>uComponents</strong> has been installed, you can activate any of the following components.</p>
    	<p>To activate these components, simply mark the ones you would like to activate, and click the "Activate Selected Components" button.</p>

		<h2>Data Types</h2>
		<asp:CheckBoxList runat="server" ID="cblDataTypes"></asp:CheckBoxList>

		<h2>UI Modules</h2>
		<asp:CheckBoxList runat="server" ID="cblUiModules">
			<asp:ListItem Text="Keyboard shortcuts &amp; drag-n-drop" Value="true" Selected="True" />
		</asp:CheckBoxList>

		<h2>Not Found Handlers</h2>
		<asp:CheckBoxList runat="server" ID="cblNotFoundHandlers"></asp:CheckBoxList>

		<h2>XSLT Extensions</h2>
		<asp:CheckBoxList runat="server" ID="cblXsltExtensions"></asp:CheckBoxList>

		<p>
            <asp:button id="btnInstall" runat="server" Text="Activate Selected Components" onclick="btnActivate_Click" onclientclick="jQuery(this).hide(); jQuery('#installingMessage').show(); return true;" />
            <div style="display: none;" id="installingMessage">
                <umb:ProgressBar runat="server" />
                <br />
                <em>&nbsp; &nbsp;Installing component(s), please wait...</em><br />
            </div>
        </p>

	</asp:PlaceHolder>

</div>