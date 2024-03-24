
fun config_schemaConnection_newApp( p, schemaName, configItem, defaultValue ) = 
	do {
		var x = p( 'schemaConnection.' ++ schemaName ++ ".newApp" ++ configItem )
		---
		if ( !isEmpty( x ) )
			x
		else
			do{
				var x = p( 'schemaConnection.default.newApp' ++ configItem )
				---
				if ( !isEmpty( x ) )
					x
				else
					defaultValue
			}
	}