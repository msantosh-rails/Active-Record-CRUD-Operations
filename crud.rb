require "dbi"

$dbh=""
class Operations

	def connection
	
		$dbh = DBI.connect("DBI:Mysql:products:localhost","root", "root")

		if $dbh
		    	puts "Connection Established"
		end
	end # connection
	
	def create
		
		# Creating Table
		$dbh.do("DROP TABLE IF EXISTS inventory")
		$dbh.do("CREATE TABLE inventory (
    			 pid  int NOT NULL,
     			pname  VARCHAR(20),
    			 price BIGINT,  
    			 vendor VARCHAR(15))");
    		puts "Table is created"
	end # Create
	
	def read

		# Read Operation
		puts "Table Contents : "
		stmt = $dbh.prepare("SELECT * FROM inventory")
		stmt.execute()
		
		print "PID\tPNAME\tPRICE\tVENDOR"
		puts " "
    
		stmt.fetch do |row|
			printf "%d\t", row[0]
		        printf "%s\t", row[1]
		        printf "%d\t", row[2]
        		printf "%s\t", row[3]
		        puts " "
		end # do
		stmt.finish
		
	end #read
	
	def insert

		 $dbh.do( "INSERT INTO inventory VALUES (101, 'Car', 100000, 'TATA')" )
		 $dbh.do( "INSERT INTO inventory VALUES (102, 'Byke', 90000, 'YAMAHA')" )
		 $dbh.do( "INSERT INTO inventory VALUES (103, 'A.C', 40000, 'SAMSUNG')" )
		 $dbh.do( "INSERT INTO inventory VALUES (104, 'T.V', 40000, 'LG')" )
		 $dbh.do( "INSERT INTO inventory VALUES (105, 'Scooter', 40000, 'BAZAZ')" )

		 puts "Five Rows created"
	end # insert
	
	def update
		
	     # Update Operation :
	     stmt = $dbh.prepare("UPDATE inventory SET price = ? WHERE pname = ?")
	     stmt.execute(2000,'T.V')
	     puts "One Row Updated"	
	     stmt.finish
          
	end #update

	def delete

	     # Delete Operation
	     stmt = $dbh.prepare("DELETE FROM inventory WHERE pid=?")
	     stmt.execute(101)
	     puts "One Row Deleted"     
	     stmt.finish
        end
end # Class

begin

oper=Operations.new
oper.connection
oper.create
oper.insert
oper.update
oper.delete
oper.read
$dbh.commit     	
rescue DBI::DatabaseError => e
     puts "An error occurred"
     puts "Error code:    #{e.err}"
     puts "Error message: #{e.errstr}"
ensure
     # disconnect from server
     $dbh.disconnect if $dbh
end
