import java.io.IOException;
import java.io.OutputStream;

import org.apache.lucene.util.BytesRef;
import org.elasticsearch.common.bytes.BytesArray;
import org.elasticsearch.common.bytes.BytesReference;
import org.elasticsearch.common.io.stream.StreamInput;
import org.elasticsearch.common.netty.buffer.ChannelBuffer;

public class User {
    public enum Gender { MALE, FEMALE };

    public static class Name {
      private String _first, _last;

      public String getFirst() { return _first; }
      public String getLast() { return _last; }

      public void setFirst(String s) { _first = s; }
      public void setLast(String s) { _last = s; }
      
      @Override
      public String toString(){
    	  return getFirst()+" "+getLast();
      }
    }

    private Gender _gender;
    private Name _name;
    private boolean _isVerified;

    public Name getName() { return _name; }
    public boolean isVerified() { return _isVerified; }
    public Gender getGender() { return _gender; }

    public void setName(Name n) { _name = n; }
    public void setVerified(boolean b) { _isVerified = b;}
    public void setGender(Gender g) { _gender = g; }
    
    @Override
    public String toString(){
    	return getName().toString();
    }
    
}
