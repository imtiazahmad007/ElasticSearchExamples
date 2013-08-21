package com.elasticlearning.services;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;

import org.codehaus.jackson.map.ObjectMapper;
import org.elasticsearch.action.bulk.BulkRequestBuilder;
import org.elasticsearch.action.bulk.BulkResponse;
import org.elasticsearch.client.Client;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.ImmutableSettings;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.elasticlearning.models.User;
import com.elasticlearning.models.User.Gender;
import com.elasticlearning.models.User.Name;


public class TestBulkIndex {

	public static void main(String [] args) throws JsonParseException, JsonMappingException, IOException{
		
		// Create User object
		User user1 = new User();
		user1.setGender(Gender.MALE);
			Name n = new Name();
				n.setFirst("Bat");
				n.setLast("Man");
		user1.setName(n);
		user1.setVerified(false);
		
		HashMap<String,Object> users = new HashMap<String,Object>();
				
		OutputStream output = new ByteArrayOutputStream();
		
		//Serialize the use1 object - Convert Java object to JSON format)
		ObjectMapper mapper = new ObjectMapper();
		mapper.writeValue(new File("user.json"), users);
		mapper.writeValue(output, user1);
		
		InputStream decodedInput=
				new ByteArrayInputStream(((ByteArrayOutputStream) output).toByteArray());

		HashMap<String,Object> result =
		        new ObjectMapper().readValue(decodedInput, HashMap.class);
		// (where JSON_SOURCE is a File, input stream, reader, or json content String)

		
		Settings settings = ImmutableSettings.settingsBuilder()
		        .put("cluster.name", "richES").build();
		
		Client client = new TransportClient(settings)
			.addTransportAddress(new InetSocketTransportAddress("123.123.123.123", 9350));
		
		BulkRequestBuilder bulkRequest = client.prepareBulk();
		
	Map<String,Object> userData = new HashMap<String,Object>();
	Map<String,String> nameStruct = new HashMap<String,String>();
	
	nameStruct.put("first", "Super");
	nameStruct.put("last", "Man");
	
	userData.put("name", nameStruct);
	userData.put("gender", "MALE");
	userData.put("verified", Boolean.FALSE);
	userData.put("userImage", "Rm9vYmFyIQ==");
	

	bulkRequest.add(client.prepareIndex("heros", "entry", "2")
			.setSource(result)
			).execute().actionGet();
	
		BulkResponse bulkResponse = bulkRequest.execute().actionGet();

		System.out.println(bulkResponse.toString());
	
	}
	
}
