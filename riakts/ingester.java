import com.basho.riak.client.api.RiakClient;
import com.basho.riak.client.api.RiakCommand;
import com.basho.riak.client.api.commands.timeseries.Store;
import com.basho.riak.client.core.RiakFuture;
import com.basho.riak.client.core.query.timeseries.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.net.UnknownHostException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.ExecutionException;

public class csvImport {
    public static void main(String[] args) throws UnknownHostException, ExecutionException, InterruptedException {
        // Riak Client with supplied IP and Port
        RiakClient client = RiakClient.newClient(8087, "127.0.0.1");

        int count = 0;

        Path pathToFile = Paths.get("/etc/resources/aisp1-20190204.csv");
        List<Row> rows = new ArrayList<>();
        try (BufferedReader br = Files.newBufferedReader(pathToFile, StandardCharsets.US_ASCII)) {

            String line = br.readLine();
            String[] headers = line.split(",");
            Map<String, Integer> map = new HashMap<>();
            for (int i = 0; i < headers.length; i++) {
                map.put(headers[i], i);
            }

            line = br.readLine();

            while (line != null) {
                List<Cell> cells = new ArrayList<>();
                String[] values = line.split(",");

                if (values.length == headers.length && !values[map.get("timestamp")].equals("")) {
                    Row row = new Row(
                            new Cell(values[map.get("timestamp")]),
                            Cell.newTimestamp(Long.parseLong(values[map.get("timestamp")])),
                            new Cell(values[map.get("type_of_mobile")]),
                            new Cell(values[map.get("mmsi")]),
                            new Cell(Double.parseDouble(values[map.get("latitude")])),
                            new Cell(Double.parseDouble(values[map.get("longitude")])),
                            new Cell(values[map.get("navigational_status")]),
                            new Cell(values[map.get("rot")]),
                            new Cell(values[map.get("sog")]),
                            new Cell(values[map.get("cog")]),
                            new Cell(values[map.get("heading")]),
                            new Cell(values[map.get("imo")]),
                            new Cell(values[map.get("callsign")]),
                            new Cell(values[map.get("name")]),
                            new Cell(values[map.get("ship_type")]),
                            new Cell(values[map.get("cargo_type")]),
                            new Cell(values[map.get("width")]),
                            new Cell(values[map.get("length")]),
                            new Cell(values[map.get("type_of_position_fixing_device")]),
                            new Cell(values[map.get("draught")]),
                            new Cell(values[map.get("destination")]),
                            new Cell(values[map.get("eta")]),
                            new Cell(values[map.get("data_source_type")]),
                            new Cell(values[map.get("a")]),
                            new Cell(values[map.get("b")]),
                            new Cell(values[map.get("c")]),
                            new Cell(values[map.get("d")]),
                            new Cell(values[map.get("sequence_id")]),
                            new Cell(Integer.parseInt(values[map.get("partition")]))
                    );
                    rows.add(row);

                }
                if (count == 1000) {
                    Store storeCmd = new Store.Builder("AIS").withRows(rows).build();
                    final RiakFuture<Void, String> storeFuture = client.executeAsync(storeCmd);
                    storeFuture.await();

                    rows = new ArrayList<>();
                    count = 0;
                    System.out.println("1000 rows has been written");
                }
                line = br.readLine();
                count++;
            }
        } catch (IOException ioe) {
            ioe.printStackTrace();
        }


        client.shutdown();
    }
}
