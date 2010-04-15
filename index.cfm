<cfinclude template="plugin/config.cfm" />

<cfif StructKeyExists(FORM, "userID")>
	<cfquery datasource="#application.configBean.getDatasource()#" name="rsUser" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SELECT	*
		FROM	tusers
		WHERE	<cfif Len(trim(form.userID))>
				userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.userID)#" />
				<cfelse>
				username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.username)#" />
				</cfif>
				AND Type = 2 
				AND inactive = 0
	</cfquery>
	<cfif rsUser.RecordCount>
		<cflogout />
		<cfset application.serviceFactory.getBean("userUtility").loginByQuery(rsUser) />
		<cflocation addtoken="false" url="http://#application.settingsManager.getSite(session.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#" />
	</cfif>
</cfif>

<cfsavecontent variable="body">
<cfoutput>
<h2>#request.pluginConfig.getName()#</h2>
<p>
	This plugin allows you to view the site as a specific user will see it.
</p>
<p>
	Simply enter the user's UserID or Username below, and you'll be logged in to the site's homepage as that user.
</p>
<form action="" method="post">
<cfif StructKeyExists(FORM, "userID")>
<p style="color: ##c00;">
	Sorry, that user could not be found.
</p>
</cfif>
<p>
	<label>UserID:</label> <input type="text" name="userID" size="35" /><br /><br />
	- OR -<br /><br />
	<label>Username:</label> <input type="text" name="username" size="35" /><br />
	<input type="submit" value="Impersonate User" />
</p>
<form>
</cfoutput>
</cfsavecontent>
<cfoutput>
#application.pluginManager.renderAdminTemplate(body=body,pageTitle=request.pluginConfig.getName())#
</cfoutput>