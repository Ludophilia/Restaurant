from http.server import BaseHTTPRequestHandler, HTTPServer
if __name__ == "__main__": from sys import argv
import json
import copy

class RestaurantData:

    categoriesLoadError = "Loaded successfully."
    menuItemsLoadError = "Loaded successfully."

    categories = []
    menuItems = []
    items_by_id = {}

    def load_data(self):
        with open("categories.json", 'r') as infile:
            try:
                self.categories = json.load(infile)
            except:
                self.categoriesLoadError = "Invalid JSON."
        
        with open("menu.json", 'r') as infile:
            try:
                self.menuItems = json.load(infile)
            except:
                self.menuItemsLoadError = "Invalid JSON."

        for item in self.menuItems:
            item['image_url'] = 'http://localhost:8090/images/' + str(item['id']) + '.png'
            self.items_by_id[item['id']] = item
    
    def __init__(self):
        self.load_data()

class RequestHandler(BaseHTTPRequestHandler):

    data = RestaurantData()

    def _set_headers(self):

        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()

    def _clean_qstring(self, qs):

        qs = qs.replace("%22", "").replace("%27", "")
        
        return qs

    def do_GET(self):

        components = self.path.split('?')    
        route = components[0]
        
        errorDict = {}

        if route == '/':

            html_response = """
                <html><body>
                <h1>Restaurant Server Running</h1>
                <h2>Categories</h2>
                <p>""" + self.data.categoriesLoadError + """</p>
                <h2>Menu Items</h2>
                <p>""" + self.data.menuItemsLoadError + """</p>
                </body></html>
            """

            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()

            self.wfile.write(html_response.encode())

        elif route == '/categories':
            json_response = json.dumps({"categories": self.data.categories})

            self._set_headers()
            self.wfile.write(json_response.encode()) 

        elif route == '/menu':
            self._set_headers()
            
            selectedItems = []
            
            if len(components) == 1:
                selectedItems = copy.deepcopy(self.data.menuItems)

            else:
                queryComponents = components[1].split('=')
                queryParam, queryValue = queryComponents[0], queryComponents[1]
                
                if queryParam == 'category':
                    if queryValue in self.data.categories:
                        for item in self.data.menuItems:
                            if item['category'] == queryValue:
                                selectedItems.append(item.copy())
                    else:
                        errorDict = {"error": "invalid category " + queryValue}
                else:
                    errorDict = {"error": "invalid query parameter " + queryParam}
            
            if len(errorDict) > 0:
                json_response = json.dumps(errorDict)
                self.wfile.write(json_response.encode())

            else:
                returnedItems = []

                for item in selectedItems:
                    if 'estimated_prep_time' in item.keys():
                        del item['estimated_prep_time']
                    returnedItems.append(item)
                
                json_response = json.dumps({"items": returnedItems})

                self.wfile.write(json_response.encode())

        elif route.startswith('/images'):
            
            self.send_response(200)
            self.send_header('Content-Type', 'image/jpeg')
            self.end_headers()
            
            imageFilePath = "images/" + self._clean_qstring(components[
                1].split("=")[1]) if len(components) > 1 else route[1:]

            with open(imageFilePath, 'rb') as file:
                self.wfile.write(file.read())
        
        else:
            self._set_headers()
            errorDict = {"error": "invalid route " + route}
            json_response = json.dumps(errorDict)

            self.wfile.write(json_response.encode())
        
    def do_HEAD(self):

        self._set_headers()

    def do_POST(self):

        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length) #b'{\n    "menuIds": [5,4]\n}'
        jsonData = json.loads(body) #{'menuIds': [5, 4]}
        returnedJSON = {}
        prepTime = 0

        if "menuIds" in jsonData.keys():
            
            menuIds = jsonData['menuIds']
            ids_not_found = []

            for id in menuIds:
                if id in self.data.items_by_id.keys():
                    prepTime += self.data.items_by_id[id]['estimated_prep_time']
                else:
                    ids_not_found.append(id)
                    
            if len(ids_not_found) > 0:
                returnedJSON = {"error": "unexpected item ids in order: " + str(ids_not_found)[1:-1]}
            else:
                returnedJSON = {"preparation_time": prepTime}
        
        else:
            returnedJSON = {"error": "expected JSON dictionary key menuIds"}
        
        json_response = json.dumps(returnedJSON)
        
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(json_response)))
        self.end_headers()
        
        self.wfile.write(json_response.encode()) 

class RestaurantServer:

    @staticmethod
    def run(server_class=HTTPServer, handler_class=RequestHandler, port=8090):
        server_address = ('', port)
        httpd = server_class(server_address, handler_class)
        print ("Starting httpd...")
        httpd.serve_forever()

def main():
    RestaurantServer.run(port=int(argv[1])) if len(argv) == 2 else RestaurantServer.run()

main()