from prisma import Prisma


class PrismaService:
    _instance = None
    _client: Prisma

    # Define singleton
    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(PrismaService, cls).__new__(cls, *args, **kwargs)
            cls._client = Prisma()
            cls._client.connect()  # Connecting to the database
        return cls._instance

    @property
    def client(self) -> Prisma:
        return self._client


prismaService = PrismaService()
