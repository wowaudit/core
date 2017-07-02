from constants import URL
from tornado import ioloop, httpclient
from time import time, sleep
class Demo:

    def with_tornado(self,zone=0):
        self.tornado_count = 0
        self.tornado_results = []
        self.tornado_params = []
        http_client = httpclient.AsyncHTTPClient()
        for character in range(10):
            self.tornado_count += 1
            url = self.get_url("sheday","stormrage")
            http_client.fetch(url, callback = lambda response, character="sheday", realm="stormrage": self.handle_request_tornado(response, character, realm), connect_timeout=400, request_timeout=400)
        ioloop.IOLoop.instance().start()
        for result in self.tornado_results:
            sleep(0.1)
        return True

    def handle_request_tornado(self, response, member, realm):
        ''' Collects the response of each individual request. '''
        self.tornado_results.append((response.body,response.code,member,realm))
        self.tornado_count -= 1
        if self.tornado_count == 0:
            ioloop.IOLoop.instance().stop()

    def get_url(self,character,zone):
        return URL.format("eu","stormrage","sheday","wgb545fvtefedpnsvrn4g5jc7quaxurn")

now = time()
a = Demo()
a.with_tornado()
print "Tornado took {0} seconds".format(time() - now)
